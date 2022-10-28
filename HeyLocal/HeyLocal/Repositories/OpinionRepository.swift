//
//  OpinionRepository.swift
//  HeyLocal
//  답변 레포지터리
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct OpinionRepository {
    private let agent = NetworkAgent()
    private let opinionUrl =  "\(Config.apiURL)/travel-ons"
    
    // 답변 목록조회
    func getOpinions(travelOnId: Int) -> AnyPublisher<[Opinion], Error> {
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        return agent.run(request)
    }
    
    // 답변 삭제
    func deleteOpinion(travelOnId: Int, opinionId: Int) {
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions/\(opinionId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        
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
                return
            }
        }.resume()
    }
    
    // 답변 등록
    func postOpinion(travelOnId: Int, opinionData: Opinion) -> Int {
        // opinionData to JSON Encoding
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(opinionData)
        var jsonStr: String = ""
        
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonStr = jsonString
        }
        
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions/"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        
        var httpResponseStatusCode: Int = 0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "No Data")
                return
            }
            httpResponseStatusCode = httpResponse.statusCode
            
            if httpResponseStatusCode == 201 {
                self.getOpinions(travelOnId: travelOnId)
                let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let resultLen = data
                let resultString = String(data: resultLen, encoding: .utf8) ?? ""
                
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let generalURL = jsonObject!["GENERAL"] as? NSArray
                let foodURL = jsonObject!["RECOMMEND_FOOD"] as? NSArray
                let cafeURL = jsonObject!["RECOMMEND_DRINK_DESSERT"] as? NSArray
                let photoSpotURL = jsonObject!["PHOTO_SPOT"] as? NSArray
                print("")
                print("====================================")
                print("[requestPOST : http post 요청 성공]")
                print("resultCode : ", resultCode)
                print("resultLen : ", resultLen)
                print("resultString : ", resultString)
                
                /// 이미지 업로드 링크 - Presigned URL
                for i in 0..<generalURL!.count {
                    print(generalURL![i])
                    
                }
                for i in 0..<foodURL!.count {
                    print(foodURL![i])
                }
                for i in 0..<cafeURL!.count {
                    print(cafeURL![i])
                }
                for i in 0..<photoSpotURL!.count {
                    print(photoSpotURL![i])
                }
                
                print("====================================")
                print("")
                
            } else {
                print("\(error?.localizedDescription)")
                
                let dataSTR = String(data: data, encoding: .utf8)!
                print(dataSTR)
                return
            }
        }
        task.resume()
        return httpResponseStatusCode
    }
    

    
    // 답변 수정
    func updateOpinion(travelOnId: Int, opinionId: Int, opinionData: Opinion) {
        // opinionData to JSON Encoding
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(opinionData)
        var jsonStr: String = ""
        
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonStr = jsonString
        }
        
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions/\(opinionId)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = jsonData
        var httpResponseStatusCode: Int = 0
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "No Data")
                return
            }
            httpResponseStatusCode = httpResponse.statusCode
            print(httpResponseStatusCode)
            if httpResponseStatusCode == 201 {
                self.getOpinions(travelOnId: travelOnId)
            } else {
                print("\(error?.localizedDescription)")
                
                let dataSTR = String(data: data, encoding: .utf8)!
                print(dataSTR)
                return
            }
        }
        task.resume()
    }
}
