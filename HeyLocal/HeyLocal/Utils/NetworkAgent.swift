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
			.tryMap(handleAPIError)
//			.map(\.data)
			.handleEvents(receiveOutput: { print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!) }) // LOG
			.decode(type: T.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
	
	/// API에서 에러를 반환한 경우 Swift 에러로 throw하는 핸들러 메서드입니다.
	private func handleAPIError(data: Data, response: URLResponse) throws -> Data {
		guard let httpResp = response as? HTTPURLResponse,
		   100..<400 ~= httpResp.statusCode
		else {
			var apiError: APIError
			
			do {
				let decoder = JSONDecoder()
				apiError = try decoder.decode(APIError.self, from: data)
			} catch {
				return data
			}
			
			throw apiError
		}
		
		return data
	}
}

// API에서 반환한 에러를 표현하기 위한 구조체입니다.
struct APIError: Error, Decodable {
	var code: String
	var description: String
}
