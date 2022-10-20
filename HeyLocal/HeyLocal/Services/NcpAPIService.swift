//
//  NcpAPIService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI

// MARK: - NcpAPIService (NAVER Cloud Platform API 호출 서비스)

class NcpAPIService {
	let agent = NetworkAgent()
	var cancelBag: Set<AnyCancellable> = []
	
	/// NCP의 Directions 5 API를 호출하여 차량 운전 시의 거리 정보를 받아옵니다.
	func searchDrivingInfo(sLat: Double, sLng: Double, eLat: Double, eLng: Double, distance: Binding<Distance>) {
		// URL 구성
		var components = URLComponents(string: "\(Config.ncpApiURL)/map-direction/v1/driving")!
		components.queryItems = [
			URLQueryItem(name: "start", value: "\(sLng),\(sLat)"),
			URLQueryItem(name: "goal", value: "\(eLng),\(eLat)"),
			URLQueryItem(name: "option", value: "trafast")
		]
		
		// Request 생성
		guard let url = components.url else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("\(Config.ncpApiId)", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
		request.addValue("\(Config.ncpApiSecret)", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
		
		// 실행
		agent.run(request)
			.sink(receiveCompletion: { completion in
				if case let .failure(error) = completion {
					distance.wrappedValue = Distance(time: 0, distance: 0)
				}
			}, receiveValue: { (resp: NcpDirectionsResponse) in
				let paths = resp.route.trafast
				let shortest = paths.min(by: { $0.summary.duration < $1.summary.duration })!
				distance.wrappedValue = shortest.summary.distanceObj
			})
			.store(in: &cancelBag)
	}
}


// MARK: - API 응답 엔티티

struct NcpDirectionsResponse: Decodable {
	var code: String
	var message: String
	var route: Route
	
	struct Route: Decodable {
		var trafast: [RouteUnit]
	}
	
	struct RouteUnit: Decodable {
		var summary: Summary
	}
	
	struct Summary: Decodable {
		var distance: Int // meters
		var duration: Int // milliseconds
		
		var distanceObj: Distance {
			Distance(time: Double(duration) / 1000 / 60, distance: Double(distance))
		}
	}
}
