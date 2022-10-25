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
    var body: some View {
        LazyVStack {
            HStack {
                
                
            }
            ForEach(viewModel.users) { user in
//                for i in 0..<3 {
                    // TODO: 사용자 프로필 화면으로 이동
                    ProfileComponent(author: user)
                        .padding()
//                }
                
            }
        }
        .onAppear {
            viewModel.getUserRanking()
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
