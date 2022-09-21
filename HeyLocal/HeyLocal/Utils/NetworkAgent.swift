//
//  NetworkAgent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct NetworkAgent {
	let session = URLSession.shared
	
	func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
		return session
			.dataTaskPublisher(for: request)
			.tryMap { data, response in
				if let httpResp = response as? HTTPURLResponse,
				   100..<400 ~= httpResp.statusCode {
					return data
				} else {
					let decoder = JSONDecoder()
					let apiError = try decoder.decode(APIError.self, from: data)
					throw apiError
				}
			}
			.decode(type: T.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}

/// API에서 반환한 에러를 표현하기 위한 구조체입니다.
struct APIError: Error, Decodable {
	var code: String
	var description: String
}
