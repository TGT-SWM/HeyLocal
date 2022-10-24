//
//  AuthRepository.swift
//  HeyLocal
//	인증(로그인, 회원가입) 레포지터리
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct AuthRepository {
	private let agent = NetworkAgent()
	
	private let signUpURL = "\(Config.apiURL)/signup"
	private let signInURL = "\(Config.apiURL)/signin"
	
	/// 아이디의 중복 여부를 체크합니다.
	func checkDuplicateId(accountId: String) -> AnyPublisher<CheckDuplicateIdResponse, Error> {
		// URLRequest
		let urlString = "\(signUpURL)/accountid?accountId=\(accountId)"
		let url = URL(string: urlString)!
		var request = URLRequest(url: url)
		
		// HTTP Headers
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		// Return
		return agent.run(request)
	}
	
	/// 회원가입을 요청합니다.
	func signUp(accountId: String, nickname: String, password: String) -> AnyPublisher<EmptyResponse, Error> {
		// URLRequest
		let urlString = "\(signUpURL)"
		let url = URL(string: urlString)!
		var request = URLRequest(url: url)
		
		// HTTP Headers
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		// HTTP Body
		let body = ["accountId": accountId, "nickname": nickname, "password": password]
		request.httpBody = try? JSONSerialization.data(withJSONObject: body)
		
		// Return
		return agent.run(request)
	}
	
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
