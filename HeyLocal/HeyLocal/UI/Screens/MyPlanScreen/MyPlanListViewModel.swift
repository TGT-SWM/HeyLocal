//
//  MyPlanListViewModel.swift
//  HeyLocal
//	작성한 플랜 리스트의 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI

// MARK: - MyPlanList.ViewModel (뷰 모델)

extension MyPlanList {
	class ViewModel: ObservableObject {
		// 의존성
		let planService = PlanService()
		let kakaoApiService = KakaoAPIService()
		
		var cancellable: AnyCancellable?
		
		@Published var myPlans = MyPlans() // 마이플랜
		@Published var editMode: EditMode = .inactive // 수정 모드
	}
}


// MARK: - 마이플랜 조회 기능

extension MyPlanList.ViewModel {
	/// 마이플랜 데이터를 요청합니다.
	func fetchMyPlans() {
		cancellable = planService.getMyPlans()
			.sink(receiveCompletion: { _ in
				self.fetchRegionImages()
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
	
	/// 플랜의 지역 이미지를 불러옵니다.
	func fetchRegionImages() {
		fetchRegionImagesFor(\.ongoing)
		fetchRegionImagesFor(\.upcoming)
		fetchRegionImagesFor(\.past)
	}
	
	/// ongoing, upcoming, 또는 past에 대한 지역 이미지를 불러옵니다.
	private func fetchRegionImagesFor(_ keypath: WritableKeyPath<MyPlans, [Plan]>) {
		for i in myPlans[keyPath: keypath].indices {
			kakaoApiService.getRegionImage(region: Binding(
				get: {
					Region(
						id: self.myPlans[keyPath: keypath][i].regionId,
						city: self.myPlans[keyPath: keypath][i].regionCity,
						state: self.myPlans[keyPath: keypath][i].regionState
					)
				},
				set: { self.myPlans[keyPath: keypath][i].regionImageURL = $0.thumbnailUrl }
			))
		}
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


// MARK: - 수정 버튼

extension MyPlanList.ViewModel {
	/// 현재 수정 모드인 경우 true를 반환합니다.
	var isEditing: Bool {
		editMode == .active
	}
	
	/// 수정 모드에 진입합니다.
	func startEditing() {
		editMode = .active
	}
	
	/// 수정 모드를 종료합니다.
	func stopEditing() {
		editMode = .inactive
	}
}
