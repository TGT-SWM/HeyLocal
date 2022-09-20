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
			if (viewModel.isMyPlanEmpty) {
				emptyView
			} else {
				contentView
			}
		}
		.padding()
		.onAppear {
			viewModel.fetchMyPlans()
		}
    }
	
	/// 마이 플랜이 없을 때 출력되는 뷰
	var emptyView: some View {
		Text("플랜이 존재하지 않습니다.")
	}
	
	// 마이 플랜이 있을 때 출력되는 뷰
	var contentView: some View {
		Group {
			if (!viewModel.ongoing.isEmpty) {
				planList(title: "지금 여행 중", plans: viewModel.ongoing)
			}
			if (!viewModel.upcoming.isEmpty) {
				planList(title: "다가오는 여행", plans: viewModel.upcoming)
			}
			if (!viewModel.past.isEmpty) {
				planList(title: "지난 여행", plans: viewModel.past)
			}
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
		NavigationLink(destination: PlanDetailScreen(plan: plan)) {
			HStack {
				Circle()
					.frame(width: 50, height: 50)
					.foregroundColor(.gray)
				
				Text(plan.regionState + " " + (plan.regionCity ?? ""))
					.fontWeight(.bold)
				Spacer()
				
				Text(DateFormat.format(plan.startDate, from: "yyyy-MM-dd", to: "M월 d일")
					 + " ~ " + DateFormat.format(plan.endDate, from: "yyyy-MM-dd", to: "M월 d일"))
					.font(.subheadline)
			}.padding(.bottom, 10)
		}.buttonStyle(PlainButtonStyle())
	}
}

struct MyPlanList_Previews: PreviewProvider {
    static var previews: some View {
		MyPlanList()
    }
}
