//
//  KakaoAPIService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - KakaoAPIService (카카오 API 호출 서비스)

struct KakaoAPIService {
	let agent = NetworkAgent()
	
	/// 장소 목록 검색 (페이징)
	func loadPlaces(query: String, page: Int, pageSize: Int, places: Binding<[Place]>) {
		// URL 구성
		var components = URLComponents(string: "\(Config.kakaoRestURL)/v2/local/search/keyword.json")!
		components.queryItems = [
			URLQueryItem(name: "query", value: query),
			URLQueryItem(name: "sort", value: "accuracy"),
			URLQueryItem(name: "page", value: "\(page)"),
			URLQueryItem(name: "size", value: "\(pageSize)")
		]
		
		// Request 생성
		guard let url = components.url else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("KakaoAK \(Config.kakaoRestKey)", forHTTPHeaderField: "Authorization")
		
		// 실행
		var cancellable = agent.run(request)
			.sink(receiveCompletion: { completion in
				if case let .failure(error) = completion {
					print(error)
				}
			}, receiveValue: { (resp: KakaoPlacesResponse) in
				let newPlaces = resp.documents.map(\.place)
				places.wrappedValue.append(contentsOf: newPlaces)
			})
	}
}

// MARK: - KakaoPlacesResponse (카카오 API 응답 객체)

struct KakaoPlacesResponse: Decodable {
	var meta: Meta
	var documents: [Document]
	
	struct Meta: Decodable {
		var totalCount: Int
		var pageableCount: Int
		var isEnd: Bool
		
		private enum CodingKeys: String, CodingKey {
			case totalCount = "total_count"
			case pageableCount = "pageable_count"
			case isEnd = "is_end"
		}
	}
	
	struct Document: Decodable {
		var id: Int
		var name: String
		var category: String
		var address: String
		var roadAddress: String
		var lat: Double
		var lng: Double
		var kakaoLink: String
		
		enum CodingKeys: String, CodingKey {
			case id = "id"
			case name = "place_name"
			case category = "category_group_code"
			case address = "address_name"
			case roadAddress = "road_address_name"
			case lat = "y"
			case lng = "x"
			case kakaoLink = "place_url"
		}
		
		var place: Place {
			Place(id: id, name: name, address: address, roadAddress: roadAddress, lat: lat, lng: lng)
		}
	}
}
