//
//  UserRepository.swift
//  HeyLocal
//	사용자 레포지터리
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct UserRepository {
	let agent = NetworkAgent()
	let userUrl = "\(Config.apiURL)/users"
	
	/// 작성한 여행 On 조회
	func getTravelOnsByUser(userId: Int, lastItemId: Int?, size: Int) -> AnyPublisher<[TravelOn], Error> {
		// URL
		var components = URLComponents(string: "\(userUrl)/\(userId)/travel-ons")!
		components.queryItems = [URLQueryItem(name: "size", value: "\(size)")]
		if let id = lastItemId {
			components.queryItems!.append(URLQueryItem(name: "lastItemId", value: "\(id)"));
		}
		
		// Request
		let url = components.url!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
		
		// API Call
		return agent.run(request)
	}
    
    
    /// 작성한 답변 조회
    func getOpinionsByUser(userId: Int, lastItemId: Int?, size: Int) -> AnyPublisher<[Opinion], Error> {
        var components = URLComponents(string: "\(userUrl)/\(userId)/opinions")!
        components.queryItems = [URLQueryItem(name: "size", value: "\(size)")]
        if let id = lastItemId {
            components.queryItems!.append(URLQueryItem(name: "lastItemId", value: "\(id)"));
        }
        
        let url = components.url!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
        
        return agent.run(request)
    }
    
    /// 사용자 프로필 조회
    func getUser(userId: Int) -> AnyPublisher<Author, Error> {
        let urlString = "\(userUrl)/\(userId)/profile"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Publisher 반환
        return agent.run(request)
    }
    
    /// 사용자 프로필 수정
    func updateUserProfile(userId: Int, userData: AuthorUpdate) {
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(userData)
        var jsonStr: String = ""
        
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonStr = jsonString
        }
        
        let urlString = "\(userUrl)/\(userId)/profile"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "NO Data")
                return
            }
            
            if httpResponse.statusCode == 200 {
                self.getUser(userId: userId)
                
                let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let resultLen = data
                let resultString = String(data: resultLen, encoding: .utf8) ?? ""
                
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(jsonObject)
                
                
                print("====================================")
                print("[requestPOST : http post 요청 성공]")
                print("resultCode : ", resultCode)
                print("resultLen : ", resultLen)
                print("resultString : ", resultString)
                print("====================================")
            } else {
                print("\(httpResponse.statusCode)")
                print(error?.localizedDescription)
                return
            }
        }
        task.resume()
    }
}
