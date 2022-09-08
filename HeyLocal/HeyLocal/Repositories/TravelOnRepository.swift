//
//  TravelOnRepository.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct TravelOnRepository {
    private let agent = NetworkAgent()
    private let travelonUrl =  "\(Config.apiURL)/travel-ons"
    
    func getTravelOns(lastItemId: Int?, pageSize: Int, regionId: Int?, sortBy: String, withOpinions: Bool?) -> AnyPublisher<[TravelOn], Error> {
        var components = URLComponents(string: travelonUrl)
        var queryItem: [URLQueryItem] = []
        
        // 옵셔널 바인딩
        if let last_item_id = lastItemId {
            print(last_item_id)
            let lastItemId = URLQueryItem(name: "pageRequest.lastItemId", value: "\(last_item_id)")
            queryItem.append(lastItemId)
        } else {
            
        }
        
        let pageSize = URLQueryItem(name: "pageRequest.size", value: "\(pageSize)")
        queryItem.append(pageSize)
        
        
        if let regionId = regionId {
            print(regionId)
            let regionId = URLQueryItem(name: "regionId", value: "\(regionId)")
            queryItem.append(regionId)
        } else {
            
        }
        
        let sortBy = URLQueryItem(name: "sortBy", value: sortBy)
        queryItem.append(sortBy)
        
        if let withOpinions = withOpinions {
            print(withOpinions)
            let withOpinions = URLQueryItem(name: "withOpinions", value: "\(withOpinions.description)")
            queryItem.append(withOpinions)
        } else {
            
        }
        
        components?.queryItems = queryItem
        var request = URLRequest(url: (components?.url)!)
        
        // HTTP 헤더 구성
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
        
        
        // Publisher 반환
        return agent.run(request)
    }
}
