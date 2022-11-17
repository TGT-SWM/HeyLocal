//
//  PlaceList.swift
//  HeyLocal
//	일정의 장소 리스트 뷰
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - 장소 리스트

extension PlanDetailScreen {
	/// 장소를 출력하는 리스트입니다.
	func placeListOf(day: Int) -> some View {
		ZStack {
			// 장소 목록이 비어 있을 때
			if (viewModel.scheduleOf(day: day).isEmpty) {
				emptyView
			}
			// 장소 목록을 출력
			else {
				List {
					listItems(day: day) // 장소 항목들
					scheduleToolbar(day: day) // 하단 버튼 뷰
				}
				.listStyle(PlainListStyle())
			}
			// 도착 시간 수정 팝업
			if viewModel.isEditingArrivalTime {
				arrivalTimeEditView
			}
		}
	}
	
	/// 장소가 비어 있을 때 출력할 뷰입니다.
	var emptyView: some View {
		VStack(alignment: .center, spacing: 0) {
			VStack(spacing: 28) {
				Text("현지인들이 추천하는 여행 명소를 찾아보세요")
					.foregroundColor(Color("gray"))
					.font(.system(size: 16))
					.fontWeight(.medium)
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets())
				
				Button {
					print(plan.regionId)
					navigateToTravelOnWithRegion(plan.regionId)
				} label: {
					Text("여행 On 바로가기")
						.font(.system(size: 14))
						.fontWeight(.medium)
						.foregroundColor(.white)
						.background(
							RoundedRectangle(cornerRadius: 100)
								.fill(Color("orange"))
								.frame(width: 150, height: 38)
						)
				}
				.buttonStyle(PlainButtonStyle())
				
				HStack { Spacer() }
			}
			.frame(height: 200)
			.background(Color.white)
			
			List {
				scheduleToolbar(day: nil)
			}
			.listStyle(PlainListStyle())
			
			Spacer()
		}
	}
}

// MARK: - 리스트

extension PlanDetailScreen {
	/// 리스트에 들어갈 항목들을 반환합니다.
	func listItems(day: Int) -> some View {
		let schedule = viewModel.scheduleOf(day: day)
		var currentPlaceIdx: Int?
		
		// 금일 스케줄인지 확인
		let isToday = viewModel.isToday(day: day)
		
		// 현재 장소에 해당하는 인덱스 값 구하기
		if isToday {
			for idx in schedule.indices {
				let place = schedule[idx].wrappedValue
				if viewModel.isCurrentPlace(lat: place.lat, lng: place.lng) {
					currentPlaceIdx = idx
				}
			}
		}
		
		// 현재 스케줄 내 어떤 장소에 있는 경우, 다음 장소까지의 예상 도착 시간 계산
		var nextPlaceIdx: Int?
		var maybeLate = false
		
		if let idx = currentPlaceIdx { // 현재 스케줄 내 장소에 위치한 경우
			let distances = viewModel.apiDistances[day - 1]
			
			if idx >= 0 && idx < distances.count { // 거리 정보가 존재하는 경우
				nextPlaceIdx = idx + 1
				let nextPlace = viewModel.placeOf(day: day, index: idx + 1).wrappedValue
				let timeInt = TimeInterval(distances[idx].time * 60)
				
				if let until = nextPlace.arrivalTime { // 도착 시간 정보가 존재하는 경우 (HH:mm:ss 포맷)
					let arrivalTime = Date().advanced(by: timeInt)
					let arrival = DateFormat.dateToStr(arrivalTime, "HH:mm:ss")
					print("until : " + until)
					print("arrival : " + arrival)
					if until < arrival { // 도착 시간에 늦는 경우
						maybeLate = true
					}
				}
			}
		}
		
		return ForEach(schedule.indices, id: \.self) { index in
			listItem(
				index: index,
				place: viewModel.placeOf(day: day, index: index),
				isCurrentPlace: index == currentPlaceIdx,
				maybeLate: (index == nextPlaceIdx) && maybeLate
			)
			
			// 마지막 항목이 아니라면, 자신과 다음 장소 사이의 거리 정보를 출력합니다.
			if index != viewModel.scheduleOf(day: day).count - 1 {
				distanceItem(day: day, index: index)
					.deleteDisabled(true)
					.moveDisabled(true)
			}
		}
		.onDelete(perform: deleteHandler(day: day))
		.onMove(perform: moveHandler(day: day))
	}
	
	/// 리스트의 항목 뷰를 반환합니다.
	func listItem(index: Int, place: Binding<Place>, isCurrentPlace: Bool, maybeLate: Bool) -> some View {
		print(place.wrappedValue)
		print(maybeLate)
		return HStack(alignment: .center) {
			// 순서
			placeOrder(order: index + 1, isCurrentPlace: isCurrentPlace)
			
			// 장소 정보
			VStack(alignment: .leading) {
				HStack {
					if let arrivalTime = place.wrappedValue.arrivalTime {
						Text("\(DateFormat.format(arrivalTime, from: "HH:mm:ss", to: "a hh:mm")) 도착")
							.font(.system(size: 12))
					} else {
						Text("도착 시간을 정해주세요")
							.font(.system(size: 12))
					}
					arrivalTimeEditButton(place: place)
				}
				
				Text(place.wrappedValue.name) // 이름
					.font(.system(size: 16))
					.fontWeight(.medium)
			}
			
			Spacer()
			
			// 도착 예상 (ex. 늦을 수 있어요)
			if maybeLate {
				HStack {
					Text("늦을 수 있어요")
					Image(systemName: "exclamationmark.circle.fill")
				}
				.font(.system(size: 12))
				.foregroundColor(Color(red: 220 / 255, green: 46 / 255, blue: 56 / 255))
			}
		}
		.frame(height: 72)
		.padding(.horizontal, 20)
		.listRowSeparator(.hidden)
		.listRowInsets(EdgeInsets())
	}
	
	/// 장소 사이의 거리와 길찾기 버튼을 보여주는 항목입니다.
	func distanceItem(day: Int, index: Int) -> some View {
		let distance = viewModel.apiDistances[day - 1][index]
		let d = distance.distance
		let t = distance.time
		
		// 이동 거리 문자열
		var distStr = ""
		if d == .infinity {
			distStr = "로드 중..."
		} else if d >= 1000 {
			distStr = String(format: "%.1f", d / 1000) + "km"
		} else {
			distStr = "\(Int(d))m"
		}
		
		// 이동 시간 문자열
		let type = (viewModel.plan.transportationType == "PUBLIC")
			? "대중교통"
			: "자가용"
		var timeStr = "\(type)으로 "
		if t == .infinity {
			timeStr = "로드 중..."
		} else if t < 2 {
			timeStr += "약 1분 소요"
		} else {
			timeStr += "약 \(Int(t))분 소요"
		}
		
		// 카카오맵 URL scheme
		let from = viewModel.scheduleOf(day: day).wrappedValue[index]
		let to = viewModel.scheduleOf(day: day).wrappedValue[index + 1]
		let urlStr = "kakaomap://route?sp=\(from.lat),\(from.lng)&ep=\(to.lat),\(to.lng)&by=CAR"
		let url = URL(string: urlStr)!
		
		return HStack(alignment: .center, spacing: 0) {
			Image("vertical_stripe_icon")
				.frame(height: 40)
				.padding(.horizontal, 32)
			
			Text("\(distStr) / \(timeStr)")
				.font(.system(size: 12))
			
			Spacer()
			
			Button {
				// 카카오맵으로 이동
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url)
				} else {
					UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id304608425")!)
				}
			} label: {
				HStack {
					Image("maps_arrow_icon")
						.frame(width: 20, height: 20)
					Text("길찾기")
						.font(.system(size: 14))
						.fontWeight(.medium)
				}
				
			}
			.padding(.trailing, 20)
		}
		.frame(height: 40)
		.listRowInsets(EdgeInsets())
	}
	
	/// 스케줄 안에서 장소의 순서를 출력합니다.
	func placeOrder(order: Int, isCurrentPlace: Bool) -> some View {
		Text("\(order)")
			.font(.system(size: 14))
			.fontWeight(.medium)
			.foregroundColor(.white)
			.padding(12)
			.background(
				Circle()
					.frame(width: 24, height: 24)
					.foregroundColor(
						isCurrentPlace
						? Color(red: 126 / 255, green: 0, blue: 217 / 255)
						: Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
					)
			)
	}
	
	/// 리스트 항목의 삭제 이벤트를 처리하는 핸들러를 반환합니다.
	func deleteHandler(day: Int) -> ((IndexSet) -> Void) {
		return { (indexSet: IndexSet) in
			viewModel.scheduleOf(day: day)
				.wrappedValue
				.remove(atOffsets: indexSet)
		}
	}
	
	/// 리스트 항목의 순서 이동 이벤트를 처리하는 핸들러를 반환합니다.
	func moveHandler(day: Int) -> ((IndexSet, Int) -> Void) {
		return { (from: IndexSet, to: Int) in
			viewModel.scheduleOf(day: day)
				.wrappedValue
				.move(fromOffsets: from, toOffset: to)
		}
	}
}


// MARK: - 스케줄 뷰의 하단 버튼

extension PlanDetailScreen {
	/// 여행 장소 추가 버튼과 최적루트 재정렬 버튼을 표시합니다.
	func scheduleToolbar(day: Int?) -> some View {
		Group {
			addPlacesButton
			if let day = day {
				rearrangeButton(day: day)
			}
		}
		.background(Color.white)
	}
	
	/// 장소 검색 화면으로 이동해 스케줄에 장소들을 추가하기 위한 버튼입니다.
	var addPlacesButton: some View {
		HStack {
			Image(systemName: "plus")
				.frame(width: 24, height: 24)
			Text("여행 장소 추가")
				.font(.system(size: 14))
				.fontWeight(.medium)
			
			NavigationLink(destination: PlaceSearchScreen(
				regionName: plan.regionName,
				onComplete: viewModel.handleAddPlaces
			)) {
				EmptyView()
			}
			.frame(width: 0)
			.opacity(0)
		}
		.foregroundColor(Color(red: 126 / 255, green: 0, blue: 217 / 255))
		.frame(height: 48)
		.frame(maxWidth: .infinity)
	}
	
	/// 스케줄을 자동으로 재정렬합니다.
	func rearrangeButton(day: Int) -> some View {
		HStack {
			Image("refresh_purple_icon")
				.frame(width: 24, height: 24)
			Text("최적루트 재정렬")
				.font(.system(size: 14))
				.fontWeight(.medium)

			NavigationLink(destination: MealSelectScreen(
				places: viewModel.scheduleOf(day: day).wrappedValue,
				onComplete: { selected in
					viewModel.rearrange(day: day, meals: selected)
				}
			))
			{ EmptyView() }
			.frame(width: 0)
			.opacity(0)
		}
		.buttonStyle(PlainButtonStyle())
		.foregroundColor(Color(red: 126 / 255, green: 0, blue: 217 / 255))
		.frame(height: 48)
		.frame(maxWidth: .infinity)
	}
}


// MARK: - 도착 시간 수정 기능

extension PlanDetailScreen {
	/// 장소의 도착 시간을 수정하기 위한 버튼입니다.
	func arrivalTimeEditButton(place: Binding<Place>) -> some View {
		Button {
			viewModel.editArrivalTimeOf(place: place)
		} label: {
			Image(systemName: "pencil")
				.font(.system(size: 12))
		}
	}
	
	/// 장소의 도착 시간을 수정하는 뷰입니다.
	var arrivalTimeEditView: some View {
		VStack {
			DatePicker("도착 시간 설정", selection: $viewModel.arrivalTimeEdited, displayedComponents: .hourAndMinute)
				.datePickerStyle(WheelDatePickerStyle())
				.labelsHidden()
				.background(Color.white)
				.padding()
			
			HStack {
				Button("취소", action: viewModel.cancelArrivalTimeChange)
				Button("확인", action: viewModel.saveArrivalTimeChange)
			}
			.padding()
		}
		.background(
			RoundedRectangle(cornerRadius: 15)
				.fill(.white)
				.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 2, x: 0, y: 1)
				.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 6, x: 0, y: 2)
		)
	}
}
