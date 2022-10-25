//
//  HomeScreen.swift
//  HeyLocal
//	홈 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationView {
            ScrollView {
                // TODO: 아티클
                
                // TODO: HOT한 장소
                
                // TODO: Travel-On
                
                // TODO: Ranking
                UserRankingScreen()
            }
            .navigationBarTitle("", displayMode: .automatic)
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
