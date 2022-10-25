//
//  UserRankingScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct UserRankingScreen: View {
    @StateObject var viewModel = ViewModel()
    @Environment(\.displayTabBar) var displayTabBar
    
    private var limit: Int = 3
    var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: gridItems) {
            ForEach(viewModel.users) { user in
                ProfileComponent(author: user)
                    .padding()
            }
        }
        .onAppear {
            viewModel.getUserRanking()
            displayTabBar(true)
        }
        .navigationTitle("노하우 랭킹")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButton { displayTabBar(false) })
    }
}

struct UserRankingScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserRankingScreen()
    }
}
