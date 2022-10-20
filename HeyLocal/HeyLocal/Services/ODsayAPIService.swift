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
	var cancelBag: Set<AnyCancellable> = []
	
	/// 대중교통 길찾기 API를 호출합니다.
	/// 출발 위도 & 경도와 도착 위도 & 경도를 파라미터로 받습니다.
	func searchPubTrans(sLat: Double, sLng: Double, eLat: Double, eLng: Double, distance: Binding<Distance>) {
		// URL 구성
		var components = URLComponents(string: "\(Config.odsayApiURL)/v1/api/searchPubTransPathT")!
		components.queryItems = [
			URLQueryItem(name: "apiKey", value: "\(Config.odsayApiKey)"),
			URLQueryItem(name: "lang", value: "0"),
			URLQueryItem(name: "SX", value: "\(sLng)"),
			URLQueryItem(name: "SY", value: "\(sLat)"),
			URLQueryItem(name: "EX", value: "\(eLng)"),
			URLQueryItem(name: "EY", value: "\(eLat)")
			
		]
		
		// Request 생성
		guard let url = components.url else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		
		// 실행
		agent.run(request)
			.sink(receiveCompletion: { completion in
				if case let .failure(error) = completion {
					distance.wrappedValue = Distance(time: 0, distance: 0)
					print(error)
				}
			}, receiveValue: { (resp: ODsayPubTransResponse) in
				let paths = resp.result.path
				let shortest = paths.min(by: { $0.info.time < $1.info.time })!
				distance.wrappedValue = shortest.info.distanceObj
			})
			.store(in: &cancelBag)
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
		var time: Int // minute
		var distance: Int // meter
		
		var distanceObj: Distance {
			Distance(time: Double(time), distance: Double(distance))
		}
		
		enum CodingKeys: String, CodingKey {
			case time = "totalTime"
			case distance = "totalDistance"
		}
	}
}
