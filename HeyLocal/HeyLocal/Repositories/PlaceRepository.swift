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
}
