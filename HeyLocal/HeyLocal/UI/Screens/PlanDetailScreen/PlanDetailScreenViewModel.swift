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
		let ncpAPIService = NcpAPIService()
		let locationService = LocationService()
		
		// 상태 값
		@Published var showMapView = false // 지도 뷰를 보여줄 것인지
		@Published var currentDay = 1 // 현재 보고 있는 여행 일자
		@Published var schedules: [DaySchedule] = [] {// 스케줄 정보
			didSet {
				calculateDistances()
				fetchDistancesByTransportationType()
			}
		}
		@Published var distances: [[[Distance]]] = [] // 장소 사이의 거리 정보
		@Published var apiDistances: [[Distance]] = [] // API 요청으로 가져온 대중교통 거리 정보
		@Published var editMode = EditMode.inactive // 스케줄 수정 모드
		@Published var isPlanTitleEditing = false // 플랜 제목이 수정 중인지
		@Published var arrivalTimeEditTarget: Binding<Place>?
		@Published var arrivalTimeEdited = Date()
		var schedulesBackUp: [DaySchedule] = [] // 스케줄 수정 취소를 위한 임시 저장
		
		@Published var lat: Double = 0 // 현재 사용자 위도
		@Published var lng: Double = 0 // 현재 사용자 경도
		
		// Combine
		var cancellable: AnyCancellable?
		
		// 파라미터
		var plan: Plan
		
		init(plan: Plan) {
			self.plan = plan
            print(plan)
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
	
	/// 장소 사이의 이동 거리와 이동 시간 정보를 가져옵니다.
	/// API 호출을 위한 fetcher 클로저를 파라미터로 받습니다.
	/// 스케줄 fetch가 완료된 후에 호출되어야 합니다.
	func fetchDistances(fetcher: @escaping (Double, Double, Double, Double, Binding<Distance>) -> Void) {
		// 초기화
		apiDistances = []
		for schedule in schedules {
			let places = schedule.places
			var tmp: [Distance] = []
			
			if places.count >= 2 {
				for _ in 0..<(places.count - 1) {
					tmp.append(Distance(time: .infinity, distance: .infinity))
				}
			}
			
			apiDistances.append(tmp)
		}
		
		// API 호출
		for i in self.schedules.indices {
			let places = self.schedules[i].places
			
			if places.count >= 2 {
				for j in 0..<(places.count - 1) {
					let cur = places[j]
					let next = places[j + 1]
					
					serialQueue.async {
						if j >= self.apiDistances[i].count { return }
						fetcher(
							cur.lat,
							cur.lng,
							next.lat,
							next.lng,
							Binding(
								get: { self.apiDistances[i][j] },
								set: { self.apiDistances[i][j] = $0 }
							)
						)
						
						usleep(500000) // 0.5sec
					}
				}
			}
		}
	}
	
	/// ODsay API를 호출해 대중교통 이동 시간과 거리 정보를 받아옵니다.
	func fetchPubDistances() {
		fetchDistances(fetcher: self.odsayAPIService.searchPubTrans)
	}
	
	/// NCP Directions 5 API를 호출해 자가용 이동 시간과 거리 정보를 받아옵니다.
	func fetchDrivingDistances() {
		fetchDistances(fetcher: self.ncpAPIService.searchDrivingInfo)
	}
	
	/// 플랜에서 사용하는 차량 정보에 따라 알맞은 이동 시간과 거리 정보를 받아옵니다. (대중교통 / 자가용)
	func fetchDistancesByTransportationType() {
		if plan.transportationType == "PUBLIC" {
			fetchPubDistances()
		} else {
			fetchDrivingDistances()
		}
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
					let dist = distanceBetween(
						lat1: places[j].lat,
						lng1: places[j].lng,
						lat2: places[k].lat,
						lng2: places[k].lng
					)
					
					distances[i][j][k] = dist
					distances[i][k][j] = dist
				}
			}
		}
	}
	
	/// 두 장소간 이동 시간과 거리를 계산해 반환합니다.
	/// 이동 거리는 Haversine 공식을 사용해 계산하며,
	/// 이동 거리를 기준 속도(40km/h)로 나누어 이동 시간을 계산합니다.
	func distanceBetween(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Distance {
		var distance = 0.0 // 이동 거리
		var time = 0.0 // 이동 시간
		
		// 이동 거리 계산
		let radiusOfEarth = 6371e3
		let degToRadian = Double.pi / 180
		
		let deltaLat = abs(lat1 - lat2) * degToRadian
		let deltaLng = abs(lng1 - lng2) * degToRadian
		
		let sinDeltaLat = sin(deltaLat / 2)
		let sinDeltaLng = sin(deltaLng / 2)
		let sqrted = sqrt(
			pow(sinDeltaLat, 2) +
			cos(lat1 * degToRadian) * cos(lat2 * degToRadian) * pow(sinDeltaLng, 2)
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
	func rearrange(day: Int, meals: [Place?]) {
		let places = scheduleOf(day: day).wrappedValue
		let weights = distances[day - 1].map { row in
			row.map { $0.time }
		}
		let startTime = DateFormat.strToDate("08:00:00", "HH:mm:ss")
		let isLastDay = day >= schedules.count
		
		// 초기화
		let engine: ScheduleEngine = TSPScheduleEngine(
			places: places,
			weights: weights,
			startTime: startTime,
			isLastDay: isLastDay,
			meals: meals
		)
		
		// 새로운 스케줄 가져와 반영
		let result = engine.run()
		schedules[day - 1].places = result
		
		// 서버에 반영
		updateSchedules()
	}
}


// MARK: - 현재 위치 관련 기능

extension PlanDetailScreen.ViewModel {
	/// 사용자의 현재 위치를 요청합니다.
	func fetchCurrentLocation() {
		locationService.requestLocation { coord in
			self.lat = coord.latitude
			self.lng = coord.longitude
			
			print("Current location")
			print(self.lat)
			print(self.lng)
		}
	}
	
	/// 넘겨 받은 일자의 날짜가 오늘과 일치하는지 검사합니다.
	func isToday(day: Int) -> Bool {
		let startDate = DateFormat.strToDate(plan.startDate, "yyyy-MM-dd")
		let timeInt = TimeInterval((day - 1) * 24 * 60 * 60)
		let advancedDate = startDate.advanced(by: timeInt)
		
		let advancedDateStr = DateFormat.dateToStr(advancedDate, "yyyy-MM-dd")
		let todayDateStr = DateFormat.dateToStr(Date(), "yyyy-MM-dd")
		
		return advancedDateStr == todayDateStr
	}
	
	/// 장소의 위도와 경도를 넘겨 받아, 현재 이 장소에 있는지의 여부를 판단합니다.
	/// 판단의 기준은 직선 거리 1km 이내입니다.
	func isCurrentPlace(lat: Double, lng: Double) -> Bool {
		let threshold = 1000.0
		let distance = distanceBetween(
			lat1: lat,
			lng1: lng,
			lat2: self.lat,
			lng2: self.lng
		).distance
		
		return distance <= threshold
	}
}
