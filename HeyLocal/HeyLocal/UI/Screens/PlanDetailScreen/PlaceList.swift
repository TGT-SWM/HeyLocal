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
			if (viewModel.scheduleOf(day: day).isEmpty) {
				Text("등록된 장소가 없습니다. 장소를 추가해보세요.")
			} else {
				List {
					ForEach(viewModel.scheduleOf(day: day).indices, id: \.self) {
						listItem(
							index: $0,
							place: viewModel.placeOf(day: day, index: $0)
						)
					}
					.onDelete(perform: deleteHandler(day: day))
					.onMove(perform: moveHandler(day: day))
				}
				.listStyle(PlainListStyle())
			}
			
			if viewModel.isEditingArrivalTime {
				arrivalTimeEditView
			}
		}
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
		.listRowSeparator(.hidden)
	}
	
	/// 스케줄 안에서 장소의 순서를 출력합니다.
	func placeOrder(order: Int) -> some View {
		Text("\(order)")
			.font(.system(size: 14))
			.fontWeight(.medium)
			.foregroundColor(.white)
			.padding()
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
