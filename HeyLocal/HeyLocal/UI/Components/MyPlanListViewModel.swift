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
		
		func fetchMyPlans() {
			cancellable = planService.getMyPlans()
				.sink(receiveCompletion: { _ in
				}, receiveValue: { myPlans in
					self.myPlans = myPlans
					print(self.myPlans)
				})
		}
	}
}
