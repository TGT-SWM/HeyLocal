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
    
    // TravelOn 전체 목록 조회
    func getTravelOnLists(lastItemId: Int?, pageSize: Int, regionId: Int?, sortBy: String, withOpinions: Bool?) -> AnyPublisher<[TravelOn], Error> {
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
    
    // TravelOn 상세조회
    func getTravelOn(travelOnId: Int) -> AnyPublisher<TravelOnDetail, Error> {
        // URLRequest 객체 생성
        let urlString = "\(travelonUrl)/\(travelOnId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Publisher 반환
        return agent.run(request)
    }
    
    func deleteTravelOn(travelOnId: Int) {
        let urlString = "\(travelonUrl)/\(travelOnId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("ERROR: error calling DELETE")
                return
            }
            
            guard let data = data else {
                print("ERROR: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("ERROR: HTTP request failed")
                print("\(request.httpMethod!) + \(request)")
                print("\(response)")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    print("ERROR: Cannot convert data to JSON")
                    return
                }
                
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("ERROR: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("ERROR: Could print JSON in String")
                    return
                }
                print(prettyPrintedJson)
            } catch {
                print("ERROR : Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
}
