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
		}
		.padding()
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
		}
	}
	
	/// 스케줄 모드에서 출력되는 뷰입니다.
	var placesView: some View {
		ScrollView {
			// 장소 추가 버튼
			Button {
			} label: {
				Text("해당 일자에 장소 추가하기")
			}.padding()
			
			// 해당 일자 장소 리스트
			PlaceList(places: viewModel.currentDayPlaces)
			
			// 일자 변경 버튼
			dayControl
		}
	}
	
	/// 지도 모드에서 출력되는 뷰입니다.
	var mapView: some View {
		ScrollView {
			Text("지도 화면입니다.")
		}
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
