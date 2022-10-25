//
//  HomeScreen.swift
//  HeyLocal
//	홈 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // TODO: 아티클
                    
                    // TODO: HOT한 장소
                    hotPlace
                    
                    // TODO: Travel-On
                    
                    // 사용자 랭킹
                    ranking
                }
            }
            .navigationBarTitle("", displayMode: .automatic)
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    //MARK: - Hot한 장소
    var hotPlace: some View {
        VStack {
            Text("요즘 HOT한 장소🔥")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            
            ScrollView(.horizontal, showsIndicators: false) {
                
            }
        }
    }
    
    
    //MARK: - 노하우 랭킹
    var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var ranking: some View {
        VStack {
            HStack {
                Text("노하우 랭킹👑")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                
                Spacer()
                
                NavigationLink(destination: UserRankingScreen()) {
                    Text("더보기")
                        .underline()
                        .font(.system(size: 12))
                        .foregroundColor(Color("gray"))
                }
                .padding()
            }

            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.rankings) { user in
                    ProfileComponent(author: user)
                        .padding()
                }
            }
            
        }
        .onAppear {
            viewModel.getUserRanking()
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
