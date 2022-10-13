//
//  ODsayAPIService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// MARK: - ODsayAPIService (ODsay LAB API 호출 서비스)

class ODsayAPIService {
	let agent = NetworkAgent()
	var cancellable: AnyCancellable?
	
	/// 대중교통 길찾기 API를 호출합니다.
	/// 출발 위도 & 경도와 도착 위도 & 경도를 파라미터로 받습니다.
	func searchPubTrans(sLat: Double, sLng: Double, eLat: Double, eLng: Double, time: Binding<Int>, distance: Binding<Int>) {
		// URL 구성
		var components = URLComponents(string: "\(Config.odsayApiURL)/v1/api/searchPubTransPathT")!
		components.queryItems = [
			URLQueryItem(name: "apiKey", value: "\(Config.odsayApiKey)"),
			URLQueryItem(name: "lang", value: "0"),
			URLQueryItem(name: "sx", value: "\(sLng)"),
			URLQueryItem(name: "sy", value: "\(sLat)"),
			URLQueryItem(name: "ex", value: "\(eLng)"),
			URLQueryItem(name: "ey", value: "\(eLat)")
		]
		
		// Request 생성
		guard let url = components.url else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		
		// 실행
		self.cancellable = agent.run(request)
			.sink(receiveCompletion: { completion in
				if case let .failure(error) = completion {
					print(error)
				}
			}, receiveValue: { (resp: ODsayPubTransResponse) in
				let paths = resp.result.path
				let shortest = paths.min(by: { $0.info.totalTime < $1.info.totalTime })!
				time.wrappedValue = shortest.info.totalTime
				distance.wrappedValue = shortest.info.totalDistance
			})
	}
}


// MARK: - API 응답 엔티티

struct ODsayPubTransResponse: Decodable {
	var result: Result
	
	struct Result: Decodable {
		var path: [Path]
	}
	
	struct Path: Decodable {
		var info: Info
	}
	
	struct Info: Decodable {
		var totalTime: Int // minute
		var totalDistance: Int // meter
	}
}
