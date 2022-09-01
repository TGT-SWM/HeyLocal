//
//  MyPlanListViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension MyPlanList {
	class ViewModel: ObservableObject {
		let planService = PlanService()
		@Published var myPlans = MyPlans()
		
		var cancellable: AnyCancellable?
		
		/// API를 호출해 마이 플랜을 가져옵니다.
		func fetchMyPlans() {
			cancellable = planService.getMyPlans()
				.sink(receiveCompletion: { _ in
				}, receiveValue: { myPlans in
					self.myPlans = myPlans
					print(self.myPlans)
				})
		}
		
		/// 진행중인 여행 배열
		var ongoing: [Plan] {
			myPlans.ongoing
		}
		
		/// 다가오는 여행 배열
		var upcoming: [Plan] {
			myPlans.upcoming
		}
		
		/// 지난 여행 배열
		var past: [Plan] {
			myPlans.past
		}
		
		/// 마이 플랜이 비어 있는지
		var isMyPlanEmpty: Bool {
			ongoing.isEmpty
			&& upcoming.isEmpty
			&& past.isEmpty
		}
	}
}
