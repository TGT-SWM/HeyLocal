//
//  PlanDetailScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct PlanDetailScreen: View {
	var plan: Plan
	
	@ObservedObject var viewModel = ViewModel()
	
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
    }
	
	var header: some View {
		HStack {
			VStack(alignment: .leading) {
				Text("\(plan.regionState) \(plan.regionCity) 여행")
					.font(.title2)
					.fontWeight(.bold)
				Text(DateFormat.format(plan.startDate) + " ~ " + DateFormat.format(plan.endDate))
					.font(.subheadline)
			}
			Spacer()
			
			VStack(alignment: .center) {
				Text("2일차")
				Text("(16일)")
			}.padding(.trailing, 5)
			
			Button {
				viewModel.showMapView.toggle()
				print(viewModel.showMapView)
			} label: {
				Image(systemName: viewModel.showMapView ? "map.fill" : "map")
					.font(.system(size: 24))
			}
		}
	}
	
	var placesView: some View {
		ScrollView {
			Button {
				
			} label: {
				Text("해당 일자에 장소 추가하기")
			}.padding()
			PlaceList(planId: 1)
		}
	}
	
	var mapView: some View {
		ScrollView {
			Text("지도 화면입니다.")
		}
	}
}

struct PlanDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
		PlanDetailScreen(plan: Plan(id: 1, regionId: 1, regionState: "서울특별시", regionCity: "강남구", startDate: "2022-09-01", endDate: "2022-09-03"))
    }
}
