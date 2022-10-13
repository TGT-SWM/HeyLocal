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
				Text("등록된 장소가 없습니다. 장소를 추가해보세요.")
			}
			// 장소 목록을 출력
			else {
				List {
					listItems(day: day) // 장소 항목들
					scheduleToolbar // 하단 버튼 뷰
				}
				.listStyle(PlainListStyle())
			}
			// 도착 시간 수정 팝업
			if viewModel.isEditingArrivalTime {
				arrivalTimeEditView
			}
		}
	}
}

// MARK: - 리스트

extension PlanDetailScreen {
	/// 리스트에 들어갈 항목들을 반환합니다.
	func listItems(day: Int) -> some View {
		ForEach(viewModel.scheduleOf(day: day).indices, id: \.self) { index in
			listItem(
				index: index,
				place: viewModel.placeOf(day: day, index: index)
			)
			
			// 마지막 항목이 아니라면, 자신과 다음 장소 사이의 거리 정보를 출력합니다.
			if index != viewModel.scheduleOf(day: day).count - 1 {
				distanceItem(day: day, index: index)
			}
		}
		.onDelete(perform: deleteHandler(day: day))
		.onMove(perform: moveHandler(day: day))
	}
	
	/// 리스트의 항목 뷰를 반환합니다.
	func listItem(index: Int, place: Binding<Place>) -> some View {
		HStack(alignment: .center) {
			placeOrder(order: index + 1)
			
			VStack(alignment: .leading) {
				HStack {
					if let arrivalTime = place.wrappedValue.arrivalTime {
						Text("\(DateFormat.format(arrivalTime, from: "HH:mm:ss", to: "a hh:mm"))")
							.font(.system(size: 12))
					} else {
						Text("도착 시간을 설정해주세요")
							.font(.system(size: 12))
					}
					arrivalTimeEditButton(place: place)
				}
				
				Text(place.wrappedValue.name) // 이름
					.font(.system(size: 16))
					.fontWeight(.medium)
			}
			
			Spacer()
		}
		.frame(height: 72)
		.padding(.horizontal, 20)
		.listRowSeparator(.hidden)
		.listRowInsets(EdgeInsets())
	}
	
	/// 장소 사이의 거리와 길찾기 버튼을 보여주는 항목입니다.
	func distanceItem(day: Int, index: Int) -> some View {
		let distance = viewModel.distances[day - 1][index][index + 1]
		let d = distance.distance
		let t = distance.time
		
		// 이동 거리 문자열
		var distStr = ""
		if d >= 1000 {
			distStr = String(format: "%.1f", d / 1000) + "km"
		} else {
			distStr = "\(Int(d))m"
		}
		
		// 이동 시간 문자열
		var timeStr = ""
		if t < 2 {
			timeStr = "약 1분 소요"
		} else {
			timeStr = "약 \(Int(t))분 소요"
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
	func placeOrder(order: Int) -> some View {
		Text("\(order)")
			.font(.system(size: 14))
			.fontWeight(.medium)
			.foregroundColor(.white)
			.padding(12)
			.background(
				Circle()
					.frame(width: 24, height: 24)
					.foregroundColor(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
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
	var scheduleToolbar: some View {
		HStack(alignment: .center) {
			addPlacesButton
			rearrangeButton
		}
		.frame(height: 56)
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
			
			NavigationLink(destination: PlaceSearchScreen(onComplete: viewModel.handleAddPlaces)) {
				EmptyView()
			}
			.frame(width: 0)
			.opacity(0)
		}
		.foregroundColor(Color(red: 126 / 255, green: 0, blue: 217 / 255))
		.frame(maxWidth: .infinity)
	}
	
	/// 스케줄을 자동으로 재정렬합니다.
	var rearrangeButton: some View {
		Button {
			
		} label: {
			Image("refresh_purple_icon")
				.frame(width: 24, height: 24)
			Text("최적루트 재정렬")
				.font(.system(size: 14))
				.fontWeight(.medium)
		}
		.buttonStyle(PlainButtonStyle())
		.foregroundColor(Color(red: 126 / 255, green: 0, blue: 217 / 255))
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
