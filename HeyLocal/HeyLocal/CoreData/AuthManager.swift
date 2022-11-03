//
//  AuthManager.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import Combine

// MARK: - AuthManager (기기의 인증 상태를 관리하는 서비스)

class AuthManager: ObservableObject {
	static let shared = AuthManager() // 공유 싱글톤 객체
	
	let context = PersistenceController.shared.container.viewContext // CoreData 컨트롤러
	
	var cancelBag: Set<AnyCancellable> = [] // 토큰 갱신 요청 시 Cancellable 객체 저장
	
	let semaphore = DispatchSemaphore(value: 1) // 토큰 갱신이 한 번만 실행되도록 Lock하는 세마포어
	
	@Published var authorized: Auth? // 현재 기기의 인증 상태
	
	var accessToken: String { // authrized.accessToken 값
		if let auth = authorized {
			return auth.accessToken
		} else {
			return ""
		}
	}
	
	private init() {}
	
	/// CoreData를 통해 기기에 저장된 인증 정보를 불러옵니다.
	func fetch() {
		var data: [Authorization] = []
		
		do {
			data = try context.fetch(Authorization.fetchRequest()) as! [Authorization]
		} catch {
			print(error.localizedDescription)
		}
		
		if let authorization = data.last {
			authorized = Auth.from(authorization)
		}
	}
	
	/// CoreData를 통해 기기에 인증 정보를 저장합니다.
	/// 저장하는 정보는 현재 기기의 인증 상태인 authroized 객체에도 반영됩니다.
	func save(_ auth: Auth) {
		// Entity 가져오기
		let entity = NSEntityDescription.entity(forEntityName: "Authorization", in: context)
		
		if let entity = entity {
			// NSManagedObject 객체 만들기
			let authorization = NSManagedObject(entity: entity, insertInto: context)
			authorization.setValue(auth.id, forKey: "id")
			authorization.setValue(auth.accountId, forKey: "accountId")
			authorization.setValue(auth.nickname, forKey: "nickname")
			authorization.setValue(auth.userRole, forKey: "userRole")
			authorization.setValue(auth.accessToken, forKey: "accessToken")
			authorization.setValue(auth.refreshToken, forKey: "refreshToken")
			
			// 삭제
			PersistenceController.shared.deleteAll(request: Authorization.fetchRequest())
			
			// 저장
			do {
				try self.context.save()
				authorized = auth
			} catch {
				print(error.localizedDescription)
			}
		}
	}
	
	/// CoreData를 통해 저장된 모든 인증 정보를 제거합니다.
	/// 현재 기기의 인증 상태인 authorized 객체도 nil로 초기화됩니다.
	/// 기기의 로그아웃을 의미합니다.
	func removeAll() {
		let request = Authorization.fetchRequest()
		if PersistenceController.shared.deleteAll(request: request) {
			authorized = nil
		}
	}
	
	/// 액세스 토큰이 만료된 경우, 토큰 갱신을 요청합니다.
	/// 만약 리프레시 토큰이 만료되었을 경우, 사용자에게 다시 로그인을 요청합니다.
	func renewAccessToken() {
		// 이미 실행 중이면 종료
		let timeOutResult = semaphore.wait(timeout: .now())
		if timeOutResult == .timedOut {
			return
		}
		
		// URLRequest 객체 생성
		let url = URL(string: "\(Config.apiURL)/auth/access-token")!
		var request = URLRequest(url: url)
		request.httpMethod = "PUT"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpBody = try? JSONSerialization.data(withJSONObject: [
			"accessToken": AuthManager.shared.accessToken,
			"refreshToken": AuthManager.shared.authorized?.refreshToken
		])
		
		// 토큰 갱신 요청
		NetworkAgent().run(request)
			.sink(
				receiveCompletion: { completion in
					// 리프레시 토큰 관련 문제가 발생한 경우, 다시 사용자 로그인
					if case let .failure(error) = completion {
						if let apiError = error as? APIError {
							let cases = ["NOT_EXIST_REFRESH_TOKEN", "EXPIRED_REFRESH_TOKEN", "NOT_MATCH_PAIR"]
							if cases.contains(apiError.code) {
								AuthManager.shared.removeAll()
							}
						}
					}
					// 세마포어 반납
					self.semaphore.signal()
				},
				receiveValue: { (token: Token) in
					if var auth = self.authorized {
						auth.accessToken = token.accessToken
						auth.refreshToken = token.refreshToken
						self.save(auth)
					}
				}
			)
			.store(in: &cancelBag)
	}
}
