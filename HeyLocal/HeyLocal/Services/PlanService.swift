//
//  PlanService.swift
//  HeyLocal
//	플랜 서비스
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

class PlanService {
	private let planRepository = PlanRepository()
	var cancelBag: Set<AnyCancellable> = []
	
	/// 마이플랜을 조회합니다.
	func getMyPlans() -> AnyPublisher<MyPlans, Error> {
		// KeyChain에서 로그인 정보 가져오기
		// TODO: 실제 로그인된 userId 가져오도록 수정
		let userId = 2
		
		// API 요청
		return planRepository.findMyPlans(userId: userId)
	}
	
	/// 플랜을 생성합니다.
	func createPlan(travelOnId: Int, onCompletion: @escaping () -> Void, onError: @escaping (Error) -> Void) {
		planRepository.createPlan(travelOnId: travelOnId)
			.sink(
				receiveCompletion: { completion in
					switch (completion) {
					case .finished:
						onCompletion()
					case .failure(let error):
						onError(error)
					}
				}, receiveValue: { _ in }
			)
			.store(in: &cancelBag)
	}
	
	/// 플랜 정보를 수정합니다.
	func updatePlan(planId: Int, planTitle: String) {
		planRepository.updatePlan(planId: planId, planTitle: planTitle)
			.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
			.store(in: &cancelBag)
	}
	
	/// 플랜을 삭제합니다.
	func deletePlan(planId: Int) {
		planRepository.deletePlan(planId: planId)
			.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
			.store(in: &cancelBag)
	}
	
	/// 플랜의 스케줄을 조회합니다.
	func getSchedules(planId: Int) -> AnyPublisher<[DaySchedule], Error> {
		return planRepository.findSchedules(planId: planId)
	}
	
	/// 플랜의 스케줄을 수정합니다.
	func updateSchedules(planId: Int, schedules: [DaySchedule]) {
		var indexedSchedules = schedules
		for i in 0..<indexedSchedules.count {
			for j in 0..<indexedSchedules[i].places.count {
				indexedSchedules[i].places[j].itemIndex = j
			}
		}
		
		planRepository.updateSchedules(planId: planId, schedules: indexedSchedules)
			.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
			.store(in: &cancelBag)
	}
	
	/// 의견을 채택하여 플랜에 장소를 추가합니다.
	func acceptOpinion(planId: Int, day: Int, opinionId: Int) {
		planRepository.acceptOpinion(planId: planId, day: day, opinionId: opinionId)
			.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
			.store(in: &cancelBag)
	}
}
