//
//  AuthRepository.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct AuthRepository {
	private let agent = NetworkAgent()
	
	private let signInURL = "\(Config.apiURL)/signin"
	
	func signIn(accountId: String, password: String) -> AnyPublisher<SignInInfo, Error> {
		// URLRequest 객체 생성
		let url = URL(string: signInURL)!
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
