//
//  KakaoAPIService.swift
//  HeyLocal
//	카카오 API 서비스
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI

// MARK: - KakaoAPIService (카카오 API 호출 서비스)

class KakaoAPIService {
	let agent = NetworkAgent()
	
	var cancellable: AnyCancellable?
    var imageURL: String = ""
    
	/// 장소 목록 검색 (페이징)
	func loadPlaces(query: String, page: Int, pageSize: Int, places: Binding<[Place]>, isLastPage: Binding<Bool>) {
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
		self.cancellable = agent.run(request)
			.sink(receiveCompletion: { completion in
				if case let .failure(error) = completion {
					print(error)
				}
			}, receiveValue: { (resp: KakaoPlacesResponse) in
				let newPlaces = resp.documents.map(\.place)
				places.wrappedValue.append(contentsOf: newPlaces)
				isLastPage.wrappedValue = resp.meta.isEnd
			})
	}

    /// 지역 Thumbanail Image
    func getRegionImage(region: Binding<Region>) {
        var regionName = region.wrappedValue.state
        if region.wrappedValue.city != nil {
            regionName.append(" ")
            regionName.append(region.wrappedValue.city!)
        }
        regionName.append(" 여행지")
        
        print(regionName)
        
        // URL 구성
        var components = URLComponents(string: "\(Config.kakaoRestURL)/v2/search/image")!
        components.queryItems = [
            URLQueryItem(name: "query", value: regionName),
            URLQueryItem(name: "sort", value: "accuracy")
        ]
        
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("KakaoAK \(Config.kakaoRestKey)", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "NO Data")
                return
            }
            if httpResponse.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(KakaoImageResponse.self, from: data)
                    region.wrappedValue.thumbnailUrl = result.documents.map(\.image_url)[0]
                } catch {
                    print("error")
                }
            }
        }.resume()
    }
    
    
    func getPlaceImage(place: Binding<Place>) {
        // URL 구성
        var components = URLComponents(string: "\(Config.kakaoRestURL)/v2/search/image")!
        components.queryItems = [
            URLQueryItem(name: "query", value: place.wrappedValue.name),
            URLQueryItem(name: "sort", value: "accuracy")
        ]
        
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("KakaoAK \(Config.kakaoRestKey)", forHTTPHeaderField: "Authorization")
 
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "NO Data")
                return
            }
            if httpResponse.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(KakaoImageResponse.self, from: data)
                    place.wrappedValue.thumbnailUrl = result.documents.map(\.image_url)[0]
                    print("Thumbnail Image URL : \(place.wrappedValue.thumbnailUrl!)")
                } catch {
                    print("error")
                }
            }
        }.resume()
    }
    
    
    func getImageUrl(query: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        // URL 구성
        var components = URLComponents(string: "\(Config.kakaoRestURL)/v2/search/image")!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "sort", value: "accuracy")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("KakaoAK \(Config.kakaoRestKey)", forHTTPHeaderField: "Authorization")
 
        
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
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
		var id: String
		var name: String
		var category: String
		var address: String
		var roadAddress: String
		var lat: String
		var lng: String
		var link: String
		
		enum CodingKeys: String, CodingKey {
			case id = "id"
			case name = "place_name"
			case category = "category_group_code"
			case address = "address_name"
			case roadAddress = "road_address_name"
			case lat = "y"
			case lng = "x"
			case link = "place_url"
		}
		
		var place: Place {
			Place(
				id: Int(id) ?? 0,
				name: name,
				category: "\(PlaceCategory.withLabel(category))",
				address: address,
				roadAddress: roadAddress,
				lat: Double(lat) ?? 0.0,
				lng: Double(lng) ?? 0.0,
				link: link
			)
		}
	}
}


// MARK: - KakaoImage (카카오 이미지 검색 API 응답 객체)
struct KakaoImageResponse: Decodable {
    var meta: Meta
    var documents: [Document]
    
    struct Meta: Decodable {
        var total_count: Int
        var pageable_count: Int
        var is_end: Bool
    }
    
    struct Document: Decodable {
        var collection: String
        var thumbnail_url: String
        var image_url: String
        var width: Int
        var height: Int
        var display_sitename: String
        var doc_url: String
        var datetime: String
    }
}
