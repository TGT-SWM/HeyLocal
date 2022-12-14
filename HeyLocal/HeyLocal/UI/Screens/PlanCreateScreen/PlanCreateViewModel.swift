//
//  PlanCreateViewModel.swift
//  HeyLocal
//	플랜 생성 화면 뷰 모델
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
		@Published var travelOns = [TravelOn]() // 여행 On 데이터
		@Published var selected: TravelOn? // 선택한 여행 On
		@Published var showAlert = false // Alert 출력 여부
		@Published var alertMessage = "" // 출력할 Alert 메시지
		
		// 페이징 관련 상태
		var lastItemId: Int?
		let size = 15
		@Published var isEnd = false
		
		// 상태를 초기화합니다.
		func clearStates() {
			travelOns = []
			selected = nil
			lastItemId = nil
			isEnd = false
		}
	}
}


// MARK: - fetchTravelOns (작성한 여행 On 불러오기)

extension PlanCreateScreen.ViewModel {
	/// 작성한 여행 On을 불러옵니다.
	func fetchTravelOns() {
		guard let userId = AuthManager.shared.authorized?.id else { return }
		userService.loadTravelOnsByUser(
			userId: userId,
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


// MARK: - 에러 발생 시 Alert 메시지

extension PlanCreateScreen.ViewModel {
	func displayAlert(_ msg: String) {
		self.alertMessage = msg
		self.showAlert = true
	}
	
	func hideAlert() {
		self.alertMessage = ""
		self.showAlert = false
	}
}
