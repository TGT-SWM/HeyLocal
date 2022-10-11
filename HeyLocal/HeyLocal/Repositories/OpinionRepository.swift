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
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
        
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
                return
            }
        }.resume()
    }
    
    // 답변 등록
    func postOpinion(travelOnId: Int, opinionData: String) {
        // opinionData to JSON Encoding
        
        let urlString = "\(opinionUrl)/\(travelOnId)/opinions/"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")

        
        
    }
    
    
    // 답변 수정
}
