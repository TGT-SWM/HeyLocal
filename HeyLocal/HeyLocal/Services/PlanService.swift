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
	
	/// 마이플랜을 조회합니다.
	func getMyPlans() -> AnyPublisher<MyPlans, Error> {
		// KeyChain에서 로그인 정보 가져오기
		// TODO: 실제 로그인된 userId 가져오도록 수정
		let userId = 2
		
		// API 요청
		return planRepository.findMyPlans(userId: userId)
	}
	
	/// 플랜의 스케줄을 조회합니다.
	func getSchedules(planId: Int) -> AnyPublisher<[DaySchedule], Error> {
		return planRepository.findSchedules(planId: planId)
	}
	
	/// 플랜을 생성합니다.
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
	
	/// 플랜을 삭제합니다.
	func deletePlan(planId: Int) {
		cancellable = planRepository.deletePlan(planId: planId)
			.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
	}
}
