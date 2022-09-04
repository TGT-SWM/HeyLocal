//
//  MyPlanScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct MyPlanScreen: View {
    var body: some View {
		NavigationView {
			ScrollView {
				MyPlanList()
			}.navigationTitle("마이 플랜")
		}.navigationViewStyle(.stack)
    }
}

struct MyPlanScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyPlanScreen()
    }
}
