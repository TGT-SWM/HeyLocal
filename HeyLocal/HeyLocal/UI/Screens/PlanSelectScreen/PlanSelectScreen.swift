//
//  PlanSelectScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct PlanSelectScreen: View {
	@ObservedObject var viewModel = ViewModel()
	
    var body: some View {
		ZStack {
			list
		}
		.background(Color("lightGray"))
		.navigationTitle("마이 플랜")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.onAppear(perform: viewModel.fetchMyPlans)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				BackButton()
			}
		}
    }
}

// MARK: - list (리스트 출력)

extension PlanSelectScreen {
	var list: some View {
		List {
			section(
				title: "지금 여행 중",
				plans: viewModel.ongoing
			)
			section(
				title: "다가오는 여행",
				plans: viewModel.upcoming
			)
			section(
				title: "지난 여행",
				plans: viewModel.past
			)
		}
		.listStyle(PlainListStyle())
	}
	
	func section(title: String, plans: [Plan]) -> some View {
		Group {
			if !plans.isEmpty {
				Section(header: sublistHeader(title: title)) {
					ForEach(plans, id: \.id) { sublistItem(plan: $0) }
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
		}
		.frame(height: 80)
		.padding(.horizontal, 21)
		.listRowInsets(EdgeInsets())
		.listRowSeparator(.hidden)
	}
}


// MARK: - Previews

struct PlanSelectScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlanSelectScreen()
    }
}
