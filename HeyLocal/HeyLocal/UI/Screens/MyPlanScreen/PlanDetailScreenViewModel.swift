//
//  PlanDetailScreenViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension PlanDetailScreen {
	class ViewModel: ObservableObject {
		let planService = PlanService()
		var plan: Plan
		
		var cancellable: AnyCancellable?
		
		@Published var showMapView = false
		@Published var currentDay = 1
		@Published var schedules: [DaySchedule] = []
		
		init(plan: Plan) {
			self.plan = plan
		}
		
		func fetchPlaces() {
			cancellable = planService.getSchedules(planId: plan.id)
				.sink(receiveCompletion: { _ in
				}, receiveValue: { schedules in
					self.schedules = schedules
				})
		}
		
		/// 현재 날짜
		var currentDate: String {
			let startDate = DateFormat.strToDate(plan.startDate, "yyyy-MM-dd")
			let advancedSeconds = (currentDay - 1) * 24 * 60 * 60
			let advancedDate = startDate.advanced(by: TimeInterval(advancedSeconds))
			return DateFormat.dateToStr(advancedDate, "d")
		}
		
		/// 현재 일자에 해당하는 장소 배열
		var currentDayPlaces: [Place] {
			let idx = currentDay - 1
			if idx < schedules.count {
				return schedules[idx].places
			}
			
			return []
		}
		
		/// 현재 일자가 여행 첫째 날인지
		var isFirstDay: Bool {
			currentDay == 1
		}
		
		/// 현재 일자가 여행 마지막 날인지
		var isLastDay: Bool {
			currentDay >= schedules.count
		}
		
		/// 다음 일자로 이동
		func goNextDay() {
			currentDay = min(currentDay + 1, schedules.count)
		}
		
		/// 이전 일자로 이동
		func goPrevDay() {
			currentDay = max(currentDay - 1, 1)
		}
	}
}
