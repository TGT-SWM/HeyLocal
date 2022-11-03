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

class AuthManager: ObservableObject {
	static let shared = AuthManager()
	
	let context = PersistenceController.shared.container.viewContext
	
	var cancelBag: Set<AnyCancellable> = []
	
	let semaphore = DispatchSemaphore(value: 1)
	
	@Published var authorized: Auth?
	
	var accessToken: String {
		if let auth = authorized {
			return auth.accessToken
		} else {
			return ""
		}
	}
	
	private init() {}
	
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
	
	func removeAll() {
		let request = Authorization.fetchRequest()
		if PersistenceController.shared.deleteAll(request: request) {
			authorized = nil
		}
	}
	
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
					if case let .failure(error) = completion {
						if let apiError = error as? APIError {
							let cases = ["NOT_EXIST_REFRESH_TOKEN", "EXPIRED_REFRESH_TOKEN", "NOT_MATCH_PAIR"]
							if cases.contains(apiError.code) {
								AuthManager.shared.removeAll()
							}
						}
					}
					
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
