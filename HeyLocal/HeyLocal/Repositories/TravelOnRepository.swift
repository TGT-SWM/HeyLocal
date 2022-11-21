//
//  TravelOnRepository.swift
//  HeyLocal
//  여행On 레포지터리 : TravelOns API 연동
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI


struct TravelOnRepository {
    private let agent = NetworkAgent()
    private let travelonUrl =  "\(Config.apiURL)/travel-ons"
    
    // 전체 여행On 조회 API
    func getTravelOnLists(lastItemId: Int?, pageSize: Int, keyword: String?, regionId: Int?, sortBy: String, withOpinions: Bool?) -> AnyPublisher<[TravelOn], Error> {
        var components = URLComponents(string: travelonUrl)
        var queryItem: [URLQueryItem] = []
        
        // Parameters 설정
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
        
        if let keyword = keyword {
            print(keyword)
            let keyword = URLQueryItem(name: "keyword", value: "\(keyword)")
            queryItem.append(keyword)
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
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        
        // Publisher 반환
        return agent.run(request)
    }
    
    
    // 여행On 상세 조회 API
    func getTravelOn(travelOnId: Int) -> AnyPublisher<TravelOn, Error> {
        // URLRequest 객체 생성
        let urlString = "\(travelonUrl)/\(travelOnId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Publisher 반환
        return agent.run(request)
    }
    
    // 여행On에 등록된 플랜 조회
	func getPlan(travelOnId: Int, onReceive: @escaping (Plan) -> Void) {
        let urlString = "\(travelonUrl)/\(travelOnId)/plan"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "No DATA")
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(Plan.self, from: data)
                    onReceive(result)
                } catch {
                    print("ERROR")
                }
            }
        }.resume()
    }
    
    // 여행On 등록 API
	func postTravelOn(travelOnData: TravelOnPost, onComplete: @escaping (Int) -> Void) {
        // travelOnData -> JSON Encoding
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(travelOnData)
        var jsonStr: String = ""

        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonStr = jsonString
        }

        let url = URL(string: travelonUrl)!
        var request = URLRequest(url: url)
        var httpResponseStatusCode: Int = 0
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse, error == nil {
				httpResponseStatusCode = httpResponse.statusCode
            }
			
			DispatchQueue.main.async {
				onComplete(httpResponseStatusCode)
			}
        }
        task.resume()
    }
    
    // 여행On 삭제 API
	func deleteTravelOn(travelOnId: Int, onComplete: @escaping () -> ()) {
        let urlString = "\(travelonUrl)/\(travelOnId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("ERROR: error calling DELETE")
				DispatchQueue.main.async { onComplete() }
                return
            }
            
            guard let data = data else {
                print("ERROR: Did not receive data")
				DispatchQueue.main.async { onComplete() }
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("ERROR: HTTP request failed")
				DispatchQueue.main.async { onComplete() }
                return
            }
			
			DispatchQueue.main.async { onComplete() }
        }.resume()
    }
    
	func updateTravelOn(travelOnId: Int, travelOnData: TravelOnPost, onComplete: @escaping (Int) -> Void) {
        // travelOnData -> JSON Encoding
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(travelOnData)
        var jsonStr: String = ""
		var httpResponseStatusCode = 0

        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonStr = jsonString
        }
        
        let urlString = "\(travelonUrl)/\(travelOnId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse, error == nil {
				httpResponseStatusCode = httpResponse.statusCode
            }
			
			DispatchQueue.main.async {
				onComplete(httpResponseStatusCode)
			}
        }
        task.resume()
    }
	
	/// 여행 On의 지역과 주소에 해당하는 지역이 일치하는지에 대한 결과를 요청합니다.
	func checkAddressWithTravelOn(travelOnId: Int, address: String) -> AnyPublisher<CheckAddressWithTravelOnResponse, Error> {
		let urlStr = "\(travelonUrl)/\(travelOnId)/address?targetAddress=\(address)"
		let encodedUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		let url = URL(string: encodedUrlStr)!
		var request = URLRequest(url: url)
		
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
		
		return agent.run(request)
	}
}
