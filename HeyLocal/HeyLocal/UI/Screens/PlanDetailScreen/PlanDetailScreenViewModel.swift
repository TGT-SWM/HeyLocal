//
//  PlanDetailScreenViewModel.swift
//  HeyLocal
//	플랜 상세 화면 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI

// MARK: - PlanDetailScreen.ViewModel (뷰 모델)

extension PlanDetailScreen {
	class ViewModel: ObservableObject {
		// 의존성
		let planService = PlanService()
		var plan: Plan
		
		// 상태 값
		@Published var showMapView = false // 지도 뷰를 보여줄 것인지
		@Published var currentDay = 1 // 현재 보고 있는 여행 일자
		@Published var schedules: [DaySchedule] = [] // 스케줄 정보
		@Published var editMode = EditMode.inactive // 스케줄 수정 모드
		@Published var isPlanTitleEditing = false // 플랜 제목이 수정 중인지
		var schedulesBackUp: [DaySchedule] = [] // 스케줄 수정 취소를 위한 임시 저장
		
		// Combine
		var cancellable: AnyCancellable?
		
		init(plan: Plan) {
			self.plan = plan
			fetchPlaces()
		}
	}
}


// MARK: - 서비스 호출

extension PlanDetailScreen.ViewModel {
	/// 서버에서 스케줄 정보를 로드합니다.
	func fetchPlaces() {
		cancellable = planService.getSchedules(planId: plan.id)
			.sink(
				receiveCompletion: { _ in },
				receiveValue: { schedules in
					self.schedules = schedules
				}
			)
	}
	
	/// 변경한 스케줄 정보를 서버에 업데이트합니다.
	func updateSchedules() {
		planService.updateSchedules(
			planId: plan.id,
			schedules: schedules
		)
	}
}


// MARK: - 여행 일자 관리

extension PlanDetailScreen.ViewModel {
	/// 현재 보고 있는 일자가 여행 첫째 날이면 true를 반환합니다.
	var isFirstDay: Bool {
		currentDay == 1
	}
	
	/// 현재 보고 있는 일자가 여행 마지막 날이면 true를 반환합니다.
	var isLastDay: Bool {
		currentDay >= schedules.count
	}
	
	/// 다음 일자로 이동합니다.
	func goNextDay() {
		currentDay = min(currentDay + 1, schedules.count)
	}
	
	/// 이전 일자로 이동합니다.
	func goPrevDay() {
		currentDay = max(currentDay - 1, 1)
	}
	
	/// 현재 보고 있는 일자의 날짜를 문자열로 반환합니다.
	var currentDate: String {
		let startDate = DateFormat.strToDate(plan.startDate, "yyyy-MM-dd")
		let advancedSeconds = (currentDay - 1) * 24 * 60 * 60
		let advancedDate = startDate.advanced(by: TimeInterval(advancedSeconds))
		return DateFormat.dateToStr(advancedDate, "d")
	}
}


// MARK: - 스케줄 조회

extension PlanDetailScreen.ViewModel {
	/// 해당 일자의 스케줄에 대해 바인딩 객체를 반환합니다.
	func scheduleOf(_ day: Int) -> Binding<[Place]> {
		Binding(
			get: { self.schedules[day - 1].places },
			set: { self.schedules[day - 1].places = $0 }
		)
	}
	
	/// 현재 보고 있는 일자의 스케줄에 대해 바인딩 객체를 반환합니다.
	var currentSchedule: Binding<[Place]> {
		scheduleOf(currentDay)
	}
}


// MARK: - 스케줄 수정 기능 (삭제, 이동, 추가)

extension PlanDetailScreen.ViewModel {
	/// 현재 스케줄 수정 모드인 경우 true를 반환합니다.
	var isEditing: Bool {
		editMode == .active
	}
	
	/// 스케줄 수정 모드에 진입합니다.
	func startEditing() {
		schedulesBackUp = schedules
		editMode = .active
	}
	
	/// 변경된 내용을 취소하고 수정 모드를 종료합니다.
	func cancelChanges() {
		schedules = schedulesBackUp
		editMode = .inactive
	}
	
	/// 변경된 내용을 반영하고 수정 모드를 종료합니다.
	func confirmChanges() {
		updateSchedules()
		editMode = .inactive
	}
	
	/// 스케줄에 장소들을 추가하고 서버에 반영합니다.
	func handleAddPlaces(places: [Place]) {
		currentSchedule.wrappedValue.append(contentsOf: places)
		updateSchedules()
	}
}


// MARK: - 플랜 제목 수정 기능

extension PlanDetailScreen.ViewModel {
	/// 플랜 제목 수정 모드로 진입합니다.
	func editPlanTitle() {
		isPlanTitleEditing = true
	}
	
	/// 플랜 제목 수정을 완료합니다.
	func savePlanTitle() {
		// TODO: API Call
		isPlanTitleEditing = false
	}
	
	/// 플랜 제목에 대한 바인딩 객체를 반환합니다.
	var planTitle: Binding<String> {
		Binding(
			get: { self.plan.title },
			set: { self.plan.title = $0 }
		)
	}
}
