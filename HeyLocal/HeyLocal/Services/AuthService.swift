//
//  AuthService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct AuthService {
	private let authRepository = AuthRepository()
	
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