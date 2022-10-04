//
//  MyPlanScreen.swift
//  HeyLocal
//	마이 플랜 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct MyPlanScreen: View {
    var body: some View {
		NavigationView {
			ZStack(alignment: .bottomTrailing) {
				VStack { MyPlanList() }
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
