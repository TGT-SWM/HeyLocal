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
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(Array(zip(0..<viewModel.users.count, viewModel.users)), id: \.0) { idx, user in
                    ZStack(alignment: .topLeading) {
                        RankingProfileComponent(author: user)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        
                        if idx == 0 {
                            Image("Rank1")
                                .resizable()
                                .frame(width: 19, height: 26)
                                .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 0))
                        }
                        else if idx == 1 {
                            Image("Rank2")
                                .resizable()
                                .frame(width: 19, height: 26)
                                .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 0))
                        }
                        else if idx == 2 {
                            Image("Rank3")
                                .resizable()
                                .frame(width: 19, height: 26)
                                .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 0))
                        }
                        else {
                            Text("\(idx + 1)")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .padding(EdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 0))
                        }
                    }
                }
            }
            .padding()
            
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
