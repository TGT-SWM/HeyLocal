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
	
	func signIn(accountId: String, password: String) -> AnyPublisher<SignInInfo, Error> {
		return authRepository.signIn(accountId: accountId, password: password)
			.map({ signInInfo in
				// TODO: KeyChain 저장 로직
				print(signInInfo) // REMOVE LATER
				return signInInfo
			})
			.eraseToAnyPublisher()
	}
}
