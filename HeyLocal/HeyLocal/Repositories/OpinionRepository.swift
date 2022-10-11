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
}
