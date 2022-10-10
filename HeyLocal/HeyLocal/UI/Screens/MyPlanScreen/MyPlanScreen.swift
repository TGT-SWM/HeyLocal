//
//  MyPlanScreen.swift
//  HeyLocal
//	마이 플랜 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct MyPlanScreen: View {
	init() {
		// 네비게이션 바 스타일 적용
		let navbarAppearance = UINavigationBarAppearance()
		navbarAppearance.configureWithOpaqueBackground()
		navbarAppearance.backgroundColor = .white
		navbarAppearance.shadowColor = .clear
		UINavigationBar.appearance().standardAppearance = navbarAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = navbarAppearance
	}
	
    var body: some View {
		NavigationView {
			ZStack(alignment: .bottomTrailing) {
				MyPlanList()
				NavigationLink(destination: PlanCreateScreen()) { FAB() }
					.padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 20))
			}
			.background(Color("lightGray"))
			.navigationTitle("마이 플랜")
			.navigationBarTitleDisplayMode(.inline)
		}.navigationViewStyle(.stack)
    }
}

struct MyPlanScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyPlanScreen()
    }
}
