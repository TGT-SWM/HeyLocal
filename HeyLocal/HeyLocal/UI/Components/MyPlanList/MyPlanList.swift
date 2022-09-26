//
//  MyPlanList.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - MyPlanList (마이플랜 리스트)

struct MyPlanList: View {
	@ObservedObject var viewModel = ViewModel()
	
    var body: some View {
		VStack {
			if (viewModel.isMyPlanEmpty) { emptyView }
			else { myPlanList }
		}
		.onAppear {
			viewModel.fetchMyPlans()
		}
    }
}


// MARK: - myPlanList (마이플랜 정보 출력)

extension MyPlanList {
	var myPlanList: some View {
		ScrollView {
			VStack {
				if (!viewModel.ongoing.isEmpty) {
					sublist(title: "지금 여행 중", plans: viewModel.ongoing)
				}
				if (!viewModel.upcoming.isEmpty) {
					sublist(title: "다가오는 여행", plans: viewModel.upcoming)
				}
				if (!viewModel.past.isEmpty) {
					sublist(title: "지난 여행", plans: viewModel.past)
				}
			}
		}.padding()
	}
	
	func sublist(title: String, plans: [Plan]) -> some View {
		VStack(alignment: .leading) {
			Text(title)
				.font(.title2)
				.fontWeight(.bold)
			ForEach(plans, id: \.id) { sublistItem(plan: $0) }
		}
		.padding(.bottom, 20)
	}
	
	func sublistItem(plan: Plan) -> some View {
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


// MARK: - emptyView (마이플랜이 비어 있는 경우에 사용)

extension MyPlanList {
	var emptyView: some View {
		Text("플랜이 존재하지 않습니다.")
	}
}


// MARK: - Previews

struct MyPlanList_Previews: PreviewProvider {
    static var previews: some View {
		MyPlanList()
    }
}
