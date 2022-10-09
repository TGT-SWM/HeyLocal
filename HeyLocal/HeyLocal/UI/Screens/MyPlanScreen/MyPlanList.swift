//
//  MyPlanList.swift
//  HeyLocal
//	작성한 플랜 리스트 뷰
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - MyPlanList (마이플랜 리스트)

struct MyPlanList: View {
	@ObservedObject var viewModel = ViewModel()
	
    var body: some View {
		list.onAppear(perform: viewModel.fetchMyPlans)
    }
}


// MARK: - list (리스트 출력)

extension MyPlanList {
	var list: some View {
		List {
			section(
				title: "지금 여행 중",
				plans: viewModel.ongoing,
				onDelete: viewModel.deleteFrom(\.ongoing)
			)
			section(
				title: "다가오는 여행",
				plans: viewModel.upcoming,
				onDelete: viewModel.deleteFrom(\.upcoming)
			)
			section(
				title: "지난 여행",
				plans: viewModel.past,
				onDelete: viewModel.deleteFrom(\.past)
			)
		}
		.listStyle(PlainListStyle())
		.toolbar { EditButton() }
	}
	
	func section(title: String, plans: [Plan], onDelete: @escaping ((IndexSet) -> Void)) -> some View {
		Group {
			if !plans.isEmpty {
				Section(header: sublistHeader(title: title)) {
					ForEach(plans, id: \.id) { sublistItem(plan: $0) }
						.onDelete(perform: onDelete)
				}
			}
		}
	}
	
	func sublistHeader(title: String) -> some View {
		ZStack(alignment: .leading) {
			Color.white
			Text(title)
				.font(.system(size: 14))
				.fontWeight(.medium)
				.padding(.horizontal, 21)
		}
		.frame(height: 40)
		.listRowInsets(EdgeInsets())
	}
	
	func sublistItem(plan: Plan) -> some View {
		HStack(alignment: .center) {
			// 썸네일 이미지
			WebImage(url: "https://www.busan.go.kr/resource/img/geopark/sub/busantour/busantour1.jpg")
				.frame(width: 56, height: 56)
				.cornerRadius(.infinity)
			
			VStack(alignment: .leading, spacing: 0) {
				// 제목
				Text(plan.title)
					.font(.system(size: 16))
					.fontWeight(.medium)
				
				// 여행 기간
				Text(DateFormat.format(plan.startDate, from: "yyyy-MM-dd", to: "yyyy.MM.dd")
					+ " ~ " + DateFormat.format(plan.endDate, from: "yyyy-MM-dd", to: "yyyy.MM.dd"))
					.font(.system(size: 12))
					.padding(.top, 5)
			}
			.padding(.leading, 3)
			Spacer()
			
			// 플랜 상세 화면으로 이동
			// 기본으로 표시되는 우측 화살표 모양을 제거하기 위해 Invisible하게 처리
			NavigationLink(destination: PlanDetailScreen(plan: plan)) { EmptyView() }
		  		.frame(width: 0)
		  		.opacity(0)
		}
		.frame(height: 80)
		.padding(.horizontal, 21)
		.listRowInsets(EdgeInsets())
		.listRowSeparator(.hidden)
	}
}


// MARK: - Previews

struct MyPlanList_Previews: PreviewProvider {
    static var previews: some View {
		MyPlanList()
    }
}
