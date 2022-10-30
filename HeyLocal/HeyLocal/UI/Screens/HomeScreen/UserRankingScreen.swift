//
//  UserRankingScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct UserRankingScreen: View {
    @StateObject var viewModel = HomeScreen.ViewModel()
    @Environment(\.displayTabBar) var displayTabBar
    
    private var limit: Int = 3
    var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        VStack {
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.users) { user in
                    RankingProfileComponent(author: user)
                        .padding()
                }
            }
            Spacer()
        }
        .onAppear {
            viewModel.getUserRanking()
            displayTabBar(false)
        }
        .navigationTitle("노하우 랭킹")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton { displayTabBar(true) })
    }
}

struct UserRankingScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserRankingScreen()
    }
}
