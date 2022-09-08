//
//  PlanDetailScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct PlanDetailScreen: View {
	var plan: Plan
	
	@ObservedObject var viewModel: ViewModel
	
	init(plan: Plan) {
		self.plan = plan
		self.viewModel = ViewModel(plan: plan)
	}
	
    var body: some View {
		VStack {
			header
			if (viewModel.showMapView) {
				mapView
			} else {
				placesView
			}
			dayControl
				.padding()
		}
		.navigationTitle("마이 플랜")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear {
			viewModel.fetchPlaces()
		}
    }
	
	/// 상단 헤더 영역입니다.
	var header: some View {
		HStack {
			VStack(alignment: .leading) {
				Text("\(plan.regionState) \(plan.regionCity) 여행")
					.font(.title2)
					.fontWeight(.bold)
				Text(DateFormat.format(plan.startDate, from: "yyyy-MM-dd", to: "M월 d일") + " ~ " + DateFormat.format(plan.endDate, from: "yyyy-MM-dd", to: "M월 d일"))
					.font(.subheadline)
			}
			Spacer()
			
			VStack(alignment: .center) {
				Text("\(viewModel.currentDay)일차")
				Text("(\(viewModel.currentDate)일)")
			}.padding(.trailing, 5)
			
			Button {
				viewModel.showMapView.toggle()
			} label: {
				Image(systemName: viewModel.showMapView ? "map.fill" : "map")
					.font(.system(size: 24))
			}
		}.padding()
	}
	
	/// 지도 모드에서 출력되는 뷰입니다.
	var mapView: some View {
		VStack {
			if !viewModel.schedules.isEmpty {
				KakaoMap(places: $viewModel.schedules[viewModel.currentDay - 1].places)
			} else {
				KakaoMap(places: .constant([]))
			}
		}
	}
	
	/// 스케줄 모드에서 출력되는 뷰입니다.
	var placesView: some View {
		VStack {
			// 장소 추가 버튼
			Button {
			} label: {
				Text("해당 일자에 장소 추가하기")
			}.padding()
			
			// 장소 리스트
			TabView(selection: $viewModel.currentDay) {
				ForEach(viewModel.schedules.indices, id: \.self) { idx in
					placesViewOf(day: idx + 1)
						.tag(idx + 1)
				}
			}
			.tabViewStyle(.page(indexDisplayMode: .never))
			.animation(.easeInOut)
		}
	}
	
	/// 해당 일자 장소 리스트
	func placesViewOf(day: Int) -> some View {
		PlaceList(places: $viewModel.schedules[day - 1].places)
	}
	
	/// 일자 이동을 위한 버튼입니다.
	var dayControl: some View {
		HStack {
			Button {
				viewModel.goPrevDay()
			} label: {
				Text("이전")
			}.disabled(viewModel.isFirstDay)
			
			Button {
				viewModel.goNextDay()
			} label: {
				Text("다음")
			}.disabled(viewModel.isLastDay)
		}
	}
}

struct PlanDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
		PlanDetailScreen(plan: Plan(id: 1, regionId: 1, regionState: "서울특별시", regionCity: "강남구", startDate: "2022-09-01", endDate: "2022-09-03"))
    }
}
