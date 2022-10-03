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
		
		// 상태
		@Published var travelOns = [TravelOn]()
		
		// 페이징 관련 상태
		var lastItemId: Int?
		let size = 15
		var isEnd = false
	}
}


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
