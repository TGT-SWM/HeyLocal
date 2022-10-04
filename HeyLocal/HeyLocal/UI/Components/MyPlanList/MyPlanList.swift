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
	}
	
	func sublist(title: String, plans: [Plan]) -> some View {
		List {
			Section(header: sublistHeader(title: title)) {
				ForEach(plans, id: \.id) { sublistItem(plan: $0) }
			}
		}
	}
	
	func sublistHeader(title: String) -> some View {
		Text(title)
			.font(.system(size: 16))
			.fontWeight(.bold)
	}
	
	func sublistItem(plan: Plan) -> some View {
		NavigationLink(destination: PlanDetailScreen(plan: plan)) {
			HStack(alignment: .center) {
				// 썸네일 이미지
				WebImage(url: "https://www.busan.go.kr/resource/img/geopark/sub/busantour/busantour1.jpg")
					.frame(width: 56, height: 56)
					.cornerRadius(.infinity)
				
				VStack(alignment: .leading, spacing: 0) {
					// 제목
					Text(plan.title)
						.font(.system(size: 16))
						.fontWeight(.bold)
					
					// 여행 기간
					Text(DateFormat.format(plan.startDate, from: "yyyy-MM-dd", to: "yyyy.MM.dd")
						 + " ~ " + DateFormat.format(plan.endDate, from: "yyyy-MM-dd", to: "yyyy.MM.dd"))
						.font(.system(size: 12))
						.foregroundColor(Color("gray"))
						.padding(.top, 5)
				}
				.padding(.leading, 3)
				Spacer()
			}
			.padding(.horizontal, 20)
			.frame(height: 80)
		}
		.buttonStyle(PlainButtonStyle())
	}
}


// MARK: - emptyView (마이플랜이 비어 있는 경우에 사용)

extension MyPlanList {
	var emptyView: some View {
		VStack(alignment: .center) {
			Text("플랜이 존재하지 않습니다.")
		}
		
	}
}


// MARK: - Previews

struct MyPlanList_Previews: PreviewProvider {
    static var previews: some View {
		MyPlanList()
    }
}
