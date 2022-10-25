//
//  AuthService.swift
//  HeyLocal
//	인증(로그인, 회원가입) 서비스
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class AuthService {
	private let authRepository = AuthRepository()
	
	var cancelBag: Set<AnyCancellable> = []
	
	/// 아이디의 중복 여부를 체크합니다.
	func checkDuplicateId(accountId: String, onReceive: @escaping (Bool) -> Void) {
		authRepository.checkDuplicateId(accountId: accountId)
			.sink(
				receiveCompletion: { _ in },
				receiveValue: {
					onReceive($0.alreadyExist)
				}
			)
			.store(in: &cancelBag)
	}
	
	/// 회원가입을 요청합니다.
	func signUp(accountId: String, nickname: String, password: String, onComplete: @escaping (String?) -> Void) {
		authRepository.signUp(accountId: accountId, nickname: nickname, password: password)
			.sink(
				receiveCompletion: { completion in
					switch completion {
					case .failure(let error):
						if let apiError = error as? APIError {
							onComplete(apiError.description)
						} else {
							onComplete("회원가입 중 오류가 발생했습니다.")
						}
					case .finished:
						onComplete(nil)
					}
				},
				receiveValue: { _ in }
			)
			.store(in: &cancelBag)
	}
	
	/// 로그인을 요청합니다.
	func signIn(accountId: String, password: String, onComplete: @escaping (String?) -> Void) {
		authRepository.signIn(accountId: accountId, password: password)
			.sink(
				receiveCompletion: { completion in
					switch completion {
					case .failure(let error):
						if let apiError = error as? APIError {
							onComplete(apiError.description)
						} else {
							onComplete("로그인 중 오류가 발생했습니다.")
						}
					case .finished:
						onComplete(nil)
					}
				},
				receiveValue: { resp in
					// TODO: 디바이스에 저장합니다.
				}
			)
			.store(in: &cancelBag)
	}
}
