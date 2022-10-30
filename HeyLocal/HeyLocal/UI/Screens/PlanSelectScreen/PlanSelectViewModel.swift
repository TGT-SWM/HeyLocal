//
//  PlanSelectViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

// MARK: - PlanSelectScreen.ViewModel (뷰 모델)

extension PlanSelectScreen {
	class ViewModel: ObservableObject {
		let planService = PlanService() // 의존성
		var cancellable: AnyCancellable? // Cancellable 임시 저장
		
		@Published var myPlans = MyPlans() // 마이플랜
		@Published var showSheet = false // 바텀시트 표시 여부
		@Published var selectedPlan: Plan?
		@Published var selectedDay: Int?
		
		var opinionId: Int // 파라미터
		
		init(opinionId: Int) {
			self.opinionId = opinionId
		}
	}
}


// MARK: - 마이플랜 조회 기능

extension PlanSelectScreen.ViewModel {
	/// 마이플랜 데이터를 요청합니다.
	func fetchMyPlans() {
		cancellable = planService.getMyPlans()
			.sink(receiveCompletion: { _ in
			}, receiveValue: { myPlans in
				self.myPlans = myPlans
			})
	}
	
	var ongoing: [Plan] { myPlans.ongoing } // 진행 중인 여행의 마이플랜
	var upcoming: [Plan] { myPlans.upcoming } // 다가오는 여행의 마이플랜
	var past: [Plan] { myPlans.past } // 지난 여행의 마이플랜
	
	var isMyPlanEmpty: Bool { // 마이플랜이 비어 있는지의 여부
		ongoing.isEmpty && upcoming.isEmpty && past.isEmpty
	}
}


// MARK: - 일자 선택 기능

extension PlanSelectScreen.ViewModel {
	// 의견 채택을 요청합니다.
	func addPlaceToPlan() {
		if let plan = selectedPlan, let day = selectedDay {
			planService.acceptOpinion(
				planId: plan.id,
				day: day,
				opinionId: opinionId
			)
		}
	}
	
	// 플랜을 선택하고 일자 선택 시트를 표시합니다.
	func selectPlan(plan: Plan) {
		self.selectedPlan = plan
		self.selectedDay = nil
		self.showSheet = true
	}
	
	// 선택된 플랜의 일자들을 문자열 배열로 반환합니다.
	var daysOfSelectedPlan: [[String]] {
		guard let plan = self.selectedPlan else { return [] }
		
		let start = DateFormat.strToDate(plan.startDate, "yyyy-MM-dd")
		let end = DateFormat.strToDate(plan.endDate, "yyyy-MM-dd")
		let dayInterval = TimeInterval(24 * 60 * 60)
		
		var result: [[String]] = []
		var curDay = 1
		var curDate = start
		
		while curDate <= end {
			let dateStr = DateFormat.dateToStr(curDate, "MM.dd")
			result.append([String(curDay), dateStr])
			curDate = curDate.advanced(by: dayInterval)
			curDay += 1
		}
		
		return result
	}
}
