//
//  NetworkAgent.swift
//  HeyLocal
//	네트워킹 모듈
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

// MARK: - NetworkAgent (네트워킹 모듈)

class NetworkAgent {
	let session = URLSession.shared
	
	var cancelBag: Set<AnyCancellable> = []
	
	/// 네트워크 요청을 수행합니다.
	func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
		return session
			.dataTaskPublisher(for: request)
			.tryMap(handleAPIError)
			.mapError(handleTokenExpiration)
			.retry(3)
			.map(handleEmptyResponse)
			.handleEvents(receiveOutput: logger)
			.decode(type: T.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
	
	/// API에서 에러를 반환한 경우 Swift 에러로 throw하는 핸들러 메서드입니다.
	private func handleAPIError(data: Data, response: URLResponse) throws -> Data {
		guard let httpResp = response as? HTTPURLResponse,
		   100..<400 ~= httpResp.statusCode
		else {
			let decoder = JSONDecoder()
			let apiError = try decoder.decode(APIError.self, from: data)
			throw apiError
		}
		
		return data
	}
	
	/// 액세스 토큰이 만료된 경우 토큰 갱신 요청을 보냅니다.
	private func handleTokenExpiration(error: Error) -> Error {
		if let apiError = error as? APIError {
			if apiError.code != "EXPIRED_TOKEN" {
				return error
			}
		}
		
		AuthManager.shared.renewAccessToken()
		return error
	}
	
	/// 빈 응답 데이터가 오는 경우 Invalid한 JSON이라 JSONDecoder에서 처리가 불가능하므로,
	/// 빈 JSON 객체 데이터로 변환합니다.
	private func handleEmptyResponse(data: Data) -> Data {
		data.isEmpty
		? "{}".data(using: .utf8)!
		: data
	}
	
	/// 응답 데이터를 콘솔에 출력합니다.
	private func logger(data: Data) {
		print("[Response]")
		print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
	}
}

/// API에서 반환한 에러를 표현하기 위한 구조체입니다.
struct APIError: Error, Decodable {
	var code: String
	var description: String
}

/// 빈 JSON 응답에 대한 엔티티입니다.
struct EmptyResponse: Decodable {}
