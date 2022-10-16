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
		let odsayAPIService = ODsayAPIService()
		var plan: Plan
		
		// 상태 값
		@Published var showMapView = false // 지도 뷰를 보여줄 것인지
		@Published var currentDay = 1 // 현재 보고 있는 여행 일자
		@Published var schedules: [DaySchedule] = [] {// 스케줄 정보
			didSet {
				calculateDistances()
			}
		}
		@Published var distances: [[[Distance]]] = [] // 장소 사이의 거리 정보
		@Published var pubDistances: [[Distance]] = [] // API 요청으로 가져온 대중교통 거리 정보
		@Published var editMode = EditMode.inactive // 스케줄 수정 모드
		@Published var isPlanTitleEditing = false // 플랜 제목이 수정 중인지
		@Published var arrivalTimeEditTarget: Binding<Place>?
		@Published var arrivalTimeEdited = Date()
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
	
	/// 수정한 플랜 제목을 서버에 업데이트합니다.
	func updatePlanTitle() {
		planService.updatePlan(
			planId: plan.id,
			planTitle: plan.title
		)
	}
	
	/// 스케줄 내 장소 간 이동 시간과 거리를 받아옵니다. (대중교통 기준)
	/// 스케줄 fetch가 완료된 후에 호출되어야 합니다.
	/// **현재 너무 많은 요청이 전송되며 에러가 반환되는 문제가 있어 사용이 어렵습니다.**
	func fetchPubDistances() {
		// 초기화
		pubDistances = []
		for schedule in schedules {
			let places = schedule.places
			var tmp: [Distance] = []
			
			if places.count >= 2 {
				for _ in 0..<(places.count - 1) {
					tmp.append(Distance())
				}
			}
			
			pubDistances.append(tmp)
		}
		
		// API 호출
		for i in schedules.indices {
			let places = schedules[i].places
			
			if places.count >= 2 {
				for j in 0..<(places.count - 1) {
					let cur = places[j]
					let next = places[j + 1]
					odsayAPIService.searchPubTrans(
						sLat: cur.lat,
						sLng: cur.lng,
						eLat: next.lat,
						eLng: next.lng,
						distance: Binding(
							get: { self.pubDistances[i][j] },
							set: { self.pubDistances[i][j] = $0 }
						)
					)
				}
			}
		}
		
//		// 초기화
//		initDistances()
//
//		// API 호출
//		for i in schedules.indices {
//			let places = schedules[i].places
//
//			for j in 0..<places.count {
//				for k in (j + 1)..<places.count {
//					let from = places[j]
//					let to = places[k]
//					odsayAPIService.searchPubTrans(
//						sLat: from.lat,
//						sLng: from.lng,
//						eLat: to.lat,
//						eLng: to.lng,
//						distance: Binding(
//							get: { self.distances[i][j][k] },
//							set: {
//								self.distances[i][j][k] = $0
//								self.distances[i][k][j] = $0
//							}
//						)
//					)
//				}
//			}
//		}
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
		return DateFormat.dateToStr(advancedDate, "MM.dd(E)")
	}
}


// MARK: - 스케줄 조회 기능

extension PlanDetailScreen.ViewModel {
	/// 해당 일자의 스케줄에 대해 바인딩 객체를 반환합니다.
	func scheduleOf(day: Int) -> Binding<[Place]> {
		Binding(
			get: { self.schedules[day - 1].places },
			set: { self.schedules[day - 1].places = $0 }
		)
	}
	
	/// 현재 보고 있는 일자의 스케줄에 대해 바인딩 객체를 반환합니다.
	var currentSchedule: Binding<[Place]> {
		scheduleOf(day: currentDay)
	}
	
	/// 해당 일자와 순서의 장소에 대해 바인딩 객체를 반환합니다.
	func placeOf(day: Int, index: Int) -> Binding<Place> {
		Binding(
			get: { self.schedules[day - 1].places[index] },
			set: { self.schedules[day - 1].places[index] = $0 }
		)
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
		updatePlanTitle()
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


// MARK: - 장소 도착 시간 수정 기능

extension PlanDetailScreen.ViewModel {
	/// 도착 시간을 수정 중이라면 true를 반환합니다.
	var isEditingArrivalTime: Bool {
		arrivalTimeEditTarget != nil
	}
	
	/// 해당 장소에 대해 도착 시간 수정 모드로 진입합니다.
	func editArrivalTimeOf(place: Binding<Place>) {
		arrivalTimeEditTarget = place
		if let arrivalTime = place.wrappedValue.arrivalTime {
			arrivalTimeEdited = DateFormat.strToDate(arrivalTime, "HH:mm:ss")
		} else {
			arrivalTimeEdited = Date()
		}
	}
	
	/// 도착 시간 변경 사항을 취소합니다.
	func cancelArrivalTimeChange() {
		arrivalTimeEditTarget = nil
	}
	
	/// 도착 시간 변경 사항을 서버에 반영합니다.
	func saveArrivalTimeChange() {
		let result = DateFormat.dateToStr(arrivalTimeEdited, "HH:mm:ss")
		arrivalTimeEditTarget?.wrappedValue.arrivalTime = result
		updateSchedules()
		arrivalTimeEditTarget = nil
	}
}


// MARK: - 이동 거리 및 시간을 계산하고 표시하는 기능

extension PlanDetailScreen.ViewModel {
	/// 모든 장소 사이의 이동 시간과 거리를 계산해 저장합니다.
	func calculateDistances() {
		// 초기화
		initDistances()
		
		// 계산
		for i in schedules.indices {
			let places = schedules[i].places
			
			for j in places.indices {
				for k in (j + 1)..<places.count {
					let dist = distanceBetween(places[j], places[k])
					distances[i][j][k] = dist
					distances[i][k][j] = dist
				}
			}
		}
	}
	
	/// 두 장소간 이동 시간과 거리를 계산해 반환합니다.
	/// 이동 거리는 Haversine 공식을 사용해 계산하며,
	/// 이동 거리를 기준 속도(40km/h)로 나누어 이동 시간을 계산합니다.
	func distanceBetween(_ a: Place, _ b: Place) -> Distance {
		var distance = 0.0 // 이동 거리
		var time = 0.0 // 이동 시간
		
		// 이동 거리 계산
		let radiusOfEarth = 6371e3
		let degToRadian = Double.pi / 180
		
		let deltaLat = abs(a.lat - b.lat) * degToRadian
		let deltaLng = abs(a.lng - b.lng) * degToRadian
		
		let sinDeltaLat = sin(deltaLat / 2)
		let sinDeltaLng = sin(deltaLng / 2)
		let sqrted = sqrt(
			pow(sinDeltaLat, 2) +
			cos(a.lat * degToRadian) * cos(b.lat * degToRadian) * pow(sinDeltaLng, 2)
		)
		
		distance = 2 * radiusOfEarth * asin(sqrted)
		
		// 이동 시간 계산
		let speed = 40.0 * 1000 / 60 // 40km/hour -> m/min 변환
		time = distance / speed
		
		return Distance(time: time, distance: distance)
	}
	
	
	/// distances 배열을 스케줄 크기에 맞게 초기화합니다.
	func initDistances() {
		distances = []
		for schedule in schedules {
			let n = schedule.places.count
			var scheduleDist: [[Distance]] = []
			
			for _ in 0..<n {
				var tmp: [Distance] = []
				for _ in 0..<n {
					let defaultValue = Distance(time: 0, distance: 0)
					tmp.append(defaultValue)
				}
				scheduleDist.append(tmp)
			}
			
			distances.append(scheduleDist)
		}
	}
}


// MARK: - 최적 루트 재정렬 기능

extension PlanDetailScreen.ViewModel {
	func rearrange(day: Int) {
		let places = scheduleOf(day: day).wrappedValue
		let weights = distances[day - 1].map { row in
			row.map { $0.time }
		}
		let startTime = DateFormat.strToDate("09:00:00", "HH:mm:ss")
		let isLastDay = day >= schedules.count
		
		// 초기화
		let engine: ScheduleEngine = TSPScheduleEngine(
			places: places,
			weights: weights,
			startTime: startTime,
			isLastDay: isLastDay
		)
		
		// 새로운 스케줄 가져와 반영
		let result = engine.run()
		schedules[day - 1].places = result
		// TODO: 서버에 반영
		// updateSchedules()
	}
}
