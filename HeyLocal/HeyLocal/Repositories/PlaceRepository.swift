//
//  PlaceRepository.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct PlaceRepository {
    private let agent = NetworkAgent()
    private let placeUrl = "\(Config.apiURL)/places"
    
    /// Hot한 장소
    func getHotPlaces() -> AnyPublisher<[Place], Error> {
        let urlString = "\(placeUrl)/hot"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Publisher 반환
        return agent.run(request)
    }
	
	/// 장소에 대해 작성된 답변들을 조회합니다.
	func getOpinions(placeId: Int, lastItemId: Int?, size: Int) -> AnyPublisher<[Opinion], Error> {
		// URLRequest 생성
		var components = URLComponents(string: "\(placeUrl)/\(placeId)/opinions")!
		components.queryItems = [URLQueryItem(name: "size", value: "\(size)")]
		if let id = lastItemId {
			components.queryItems!.append(URLQueryItem(name: "lastItemId", value: "\(id)"));
		}
		
		let url = components.url!
		var request = URLRequest(url: url)
		
		// HTTP 헤더 작성
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
		
		// Publisher 반환
		return agent.run(request)
	}
}
