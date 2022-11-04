//
//  UserRepository.swift
//  HeyLocal
//	사용자 레포지터리
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI


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
		request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
		
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
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
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
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Publisher 반환
        return agent.run(request)
    }
    
    /// 사용자 프로필 수정
    func updateUserProfile(userId: Int, userData: AuthorUpdate, profileImage: [UIImage], isDeleted: Bool) {
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
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        
        let httpBody = String(data: jsonData!, encoding: .utf8) ?? ""
        print("HTTP BODY", httpBody)
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
                let deleteURL = jsonObject!["deleteUrl"]
                let updateURL = jsonObject!["updatePutUrl"]
                let putURL = jsonObject!["newPutUrl"]
                
                print("====================================")
                print("[requestPOST : http post 요청 성공]")
                print("resultCode : ", resultCode)
                print("resultLen : ", resultLen)
                print("resultString : ", resultString)
                print("deleteUrl : ", deleteURL!)
                print("updateUrl : ", updateURL!)
                print("putUrl : ", putURL!)
                print("====================================")
                
                
                /// 프로필 이미지 삭제
                if isDeleted {
                    let deleteUrl = URL(string: deleteURL as! String)!
                    var deleteRequest = URLRequest(url: deleteUrl)
                    
                    deleteRequest.httpMethod = "DELETE"
//                    deleteRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")
                    
                    let deleteTask = URLSession.shared.dataTask(with: deleteRequest) { data, response, error in
                        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                            print(error?.localizedDescription ?? "NO Data")
                            return
                        }
                    }
                    
                    deleteTask.resume()
                }
                else {
                    
                    /// 프로필 이미지 수정
                    if (updateURL! as! String) != "" {
                        let updateUrl = URL(string: updateURL as! String)!
                        var updateRequest = URLRequest(url: updateUrl)
                        
                        updateRequest.httpMethod = "PUT"
                        updateRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")
                        
                        updateRequest.httpBody = profileImage[0].jpegData(compressionQuality: 1)
                        
                        let updateTask = URLSession.shared.dataTask(with: updateRequest) { data, response, error in
                            guard let data = data else {
                                return
                            }
                        }
                        updateTask.resume()
                    }
                    
                    /// 프로필 이미지 등록
                    else {
                        let putUrl = URL(string: putURL as! String)!
                        var putRequest = URLRequest(url: putUrl)

                        putRequest.httpMethod = "PUT"
                        putRequest.addValue("image/png", forHTTPHeaderField: "Content-Type")

                        putRequest.httpBody = profileImage[0].jpegData(compressionQuality: 1)

                        let putTask = URLSession.shared.dataTask(with: putRequest) { data, response, error in
                            guard let data = data else {
                                return
                            }
                        }
                        putTask.resume()
                    }
                }
            } else {
                print("\(httpResponse.statusCode)")
                print(error?.localizedDescription)
                return
            }
        }
        task.resume()
    }
    
    /// 사용자 랭킹 조회
    func getUserRanking() -> AnyPublisher<[Author], Error> {
        let urlString = "\(userUrl)/ranking"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Publisher 반환
        return agent.run(request)
    }
	
	/// 회원 탈퇴를 요청합니다.
	func deleteAccount(id: Int) -> AnyPublisher<EmptyResponse, Error> {
		// URLRequest 객체 생성
		let url = URL(string: "\(userUrl)/\(id)")!
		var request = URLRequest(url: url)
		
		// HTTP 헤더 구성
		request.httpMethod = "DELETE"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
		
		// Publisher 반환
		return agent.run(request);
	}
}
