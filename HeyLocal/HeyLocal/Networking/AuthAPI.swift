//
//  AuthAPI.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct AuthAPI {
	private let agent = NetworkAgent()
	
	private let signInUrl = "http://test.heylocal.p-e.kr/signin"
	
	func signIn(accountId: String, password: String) -> AnyPublisher<SignInDTO, Error> {
		// URLRequest 객체 생성
		let url = URL(string: signInUrl)!
		var request = URLRequest(url: url)
		
		// HTTP 헤더 구성
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		// HTTP 바디 구성
		let body = ["accountId": accountId, "password": password]
		request.httpBody = try? JSONSerialization.data(withJSONObject: body)
		
		// Publisher 반환
		return agent.run(request);
	}
}


