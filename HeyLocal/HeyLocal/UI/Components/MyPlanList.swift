//
//  MyPlanList.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct MyPlanList: View {
	@ObservedObject var viewModel = ViewModel()
	
    var body: some View {
		VStack {
			if (!viewModel.myPlans.ongoing.isEmpty) {
				planList(title: "지금 여행 중", plans: viewModel.myPlans.ongoing)
			}
			if (!viewModel.myPlans.upcoming.isEmpty) {
				planList(title: "다가오는 여행", plans: viewModel.myPlans.upcoming)
			}
			if (!viewModel.myPlans.past.isEmpty) {
				planList(title: "지난 여행", plans: viewModel.myPlans.past)
			}
		}
		.padding()
		.onAppear {
			viewModel.fetchMyPlans()
		}
    }
	
	/// Plan에 대한 리스트 및 리스트의 제목
	func planList(title: String, plans: [Plan]) -> some View {
		VStack(alignment: .leading) {
			Text(title)
				.font(.title2)
				.fontWeight(.bold)
			ForEach(plans, id: \.id) { listItem(plan: $0) }
		}.padding(.bottom, 20)
	}
	
	/// List 내의 각 Plan에 해당하는 항목
	func listItem(plan: Plan) -> some View {
		HStack {
			Circle()
				.frame(width: 50, height: 50)
				.foregroundColor(.gray)
			
			Text(plan.regionState + " " + plan.regionCity)
				.fontWeight(.bold)
			Spacer()
			
			Text(DateFormat.format(plan.startDate) + " ~ " + DateFormat.format(plan.endDate))
				.font(.subheadline)
		}.padding(.bottom, 10)
	}
}

struct MyPlanList_Previews: PreviewProvider {
    static var previews: some View {
		MyPlanList()
    }
}
