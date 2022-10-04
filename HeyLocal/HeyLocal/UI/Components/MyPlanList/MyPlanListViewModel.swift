//
//  MyPlanListViewModel.swift
//  HeyLocal
//	작성한 플랜 리스트의 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

// MARK: - MyPlanList.ViewModel (뷰 모델)

extension MyPlanList {
	class ViewModel: ObservableObject {
		let planService = PlanService() // 의존성
		var cancellable: AnyCancellable? // Cancellable 임시 저장
		
		@Published var myPlans = MyPlans() // 마이플랜
	}
}


// MARK: - 마이플랜 조회 기능

extension MyPlanList.ViewModel {
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


// MARK: - 마이플랜 삭제 기능

extension MyPlanList.ViewModel {
	func deleteFrom(_ keypath: WritableKeyPath<MyPlans, [Plan]>) -> ((IndexSet) -> Void) {
		let handler = { (at: IndexSet) in
			guard let index = at.first else { return }
			let plan = self.myPlans[keyPath: keypath][index]
			
			self.myPlans[keyPath: keypath].remove(atOffsets: at) // 상태에서 제거
			self.planService.deletePlan(planId: plan.id) // API 호출
		}
		
		return handler
	}
}
