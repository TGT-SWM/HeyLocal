//
//  PlanService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

class PlanService {
	private let planRepository = PlanRepository()
	
	var cancellable: AnyCancellable?
	
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
	
	func createPlan(travelOnId: Int, onCompletion: @escaping () -> Void, onError: @escaping (Error) -> Void) {
		cancellable = planRepository.createPlan(travelOnId: travelOnId)
			.sink(receiveCompletion: { completion in
				switch (completion) {
				case .finished:
					onCompletion()
				case .failure(let error):
					onError(error)
				}
			}, receiveValue: { _ in })
	}
}
