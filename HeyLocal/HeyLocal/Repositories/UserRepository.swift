//
//  UserRepository.swift
//  HeyLocal
//	사용자 레포지터리
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct UserRepository {
	let agent = NetworkAgent()
	let userUrl = "\(Config.apiURL)/users"
	
	/// 작성한 여행 On 조회
	func getTravelOnsByUser(userId: Int, lastItemId: Int?, size: Int) -> AnyPublisher<[TravelOn], Error> {
		// URL
		var components = URLComponents(string: "\(userUrl)/\(userId)/travel-ons")!
		components.queryItems = [URLQueryItem(name: "size", value: "\(size)")]
		if let id = lastItemId {
			components.queryItems!.append(URLQueryItem(name: "lastItemId", value: "\(id)"));
		}
		
		// Request
		let url = components.url!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
		
		// API Call
		return agent.run(request)
	}
    
    
}
