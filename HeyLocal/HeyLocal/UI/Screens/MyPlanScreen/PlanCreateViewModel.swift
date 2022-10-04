//
//  PlanCreateViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - PlanCreateScreen.ViewModel (뷰 모델)

extension PlanCreateScreen {
	class ViewModel: ObservableObject {
		// 의존성
		private let userService = UserService()
		private let planService = PlanService()
		
		// 상태
		@Published var travelOns = [TravelOn]()
		@Published var selected: TravelOn?
		@Published var showAlert = false
		
		// 페이징 관련 상태
		var lastItemId: Int?
		let size = 15
		var isEnd = false
	}
}


// MARK: - fetchTravelOns (작성한 여행 On 불러오기)

extension PlanCreateScreen.ViewModel {
	func fetchTravelOns() {
		userService.loadTravelOnsByUser(
			userId: 2,
			lastItemId: Binding(
				get: { self.lastItemId },
				set: { self.lastItemId = $0 }
			),
			size: size,
			travelOns: Binding(
				get: { self.travelOns },
				set: { self.travelOns = $0 }
			),
			isEnd: Binding(
				get: { self.isEnd },
				set: { self.isEnd = $0 }
			)
		)
		
		
	}
}


// MARK: - 여행 On 선택

extension PlanCreateScreen.ViewModel {
	func pickTravelOn(_ target: TravelOn) {
		if self.selected?.id == target.id {
			self.selected = nil
		} else {
			self.selected = target
		}
	}
	
	func submit(onCompletion: @escaping () -> Void, onError: @escaping (Error) -> Void) {
		guard let travelOn = self.selected else { return }
		planService.createPlan(travelOnId: travelOn.id, onCompletion: onCompletion, onError: onError)
	}
}
