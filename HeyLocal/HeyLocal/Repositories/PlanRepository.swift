//
//  PlanRepository.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct PlanRepository {
	private let agent = NetworkAgent()
	
	private let plansUrl = "\(Config.apiURL)/plans"
	
	/// 마이플랜을 조회합니다.
	func findMyPlans(userId: Int) -> AnyPublisher<MyPlans, Error> {
		// URLRequest 객체 생성
		let url = URL(string: plansUrl)!
		var request = URLRequest(url: url)
		
		// HTTP 헤더 구성
		// TODO: KeyChain에서 실제 토큰 가져와 Header에 작성하도록 수정
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
		
		// Publisher 반환
		return agent.run(request)
	}
	
	/// 플랜의 스케줄을 조회합니다.
	func findSchedules(planId: Int) -> AnyPublisher<[DaySchedule], Error> {
		// URLRequest 객체 생성
		let urlString = "\(Config.apiURL)/plans/\(planId)/places"
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
	
	/// 플랜을 생성합니다.
	func createPlan(travelOnId: Int) -> AnyPublisher<EmptyResponse, Error> {
		// URLRequest 생성
		let url = URL(string: "\(Config.apiURL)/plans")!
		var request = URLRequest(url: url)
		
		// HTTP Header
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
		
		let body = ["travelOnId": travelOnId]
		request.httpBody = try? JSONSerialization.data(withJSONObject: body)
		
		// Publisher 반환
		return agent.run(request)
	}
	
	/// 플랜을 삭제합니다.
	func deletePlan(planId: Int) -> AnyPublisher<EmptyResponse, Error> {
		// URLRequest 생성
		let url = URL(string: "\(Config.apiURL)/plans/\(planId)")!
		var request = URLRequest(url: url)
		
		// HTTP Header
		request.httpMethod = "DELETE"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
		
		// Publisher 반환
		return agent.run(request)
	}
}
