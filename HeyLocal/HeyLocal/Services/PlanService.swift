//
//  PlanService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct PlanService {
	private let planRepository = PlanRepository()
	
	func getMyPlans() -> AnyPublisher<MyPlans, Error> {
		// KeyChain에서 로그인 정보 가져오기
		// TODO: 실제 로그인된 userId 가져오도록 수정
		let userId = 2
		
		// API 요청
		return planRepository.findMyPlans(userId: userId)
	}
	
	func getSchedules(planId: Int) -> AnyPublisher<[DaySchedule], Error> {
		return planRepository.findSchedules(planId: planId)
	}
}
