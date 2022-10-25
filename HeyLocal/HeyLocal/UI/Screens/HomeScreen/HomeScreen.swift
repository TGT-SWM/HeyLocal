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
                    
                    // HOT한 장소
                    Group {
                        Text("요즘 HOT한 장소🔥")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                        HotPlace()
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
                        
                        Spacer()
                            .frame(height: 20)
                        
                    }
                    
                    // TODO: Travel-On
                    Group {
                        Divider()
                        
                        Spacer()
                            .frame(height: 20)
                
                        Text("현지인의 추천이 궁금해요😮")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                        RecentTravelOn()
                        
                        Spacer()
                            .frame(height: 20)
                    }
                    // 사용자 랭킹
                    Group {
                        Divider()
                        
                        Spacer()
                            .frame(height: 10)
                        
                        HStack {
                            Text("노하우 랭킹👑")
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            NavigationLink(destination: UserRankingScreen()) {
                                Text("더보기")
                                    .underline()
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("gray"))
                            }
                        }
                        .padding()
                        
                        Ranking()
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    }
                }
            }
            .navigationBarTitle("", displayMode: .automatic)
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// MARK: - Hot한 장소
extension HomeScreen {
    struct HotPlace: View {
        @StateObject var viewModel = ViewModel()
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.hotplaces) { place in
                        HotPlaceComponent(place: place)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                }
            }
            .onAppear {
                viewModel.getHotPlaces()
            }
        }
    }
}


// MARK: - 여행On
extension HomeScreen {
    struct RecentTravelOn: View {
        @StateObject var viewModel = ViewModel()
        var body: some View {
            VStack {
                ForEach(viewModel.travelOns) { travelOn in
                    NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOn.id)){
                        TravelOnComponent(travelOn: travelOn)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                }
            }
            .onAppear {
                viewModel.getRecentTravelOns()
            }
        }
    }
}

// MARK: - 사용자 노하우 랭킹
extension HomeScreen {
    struct Ranking: View {
        
        var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        @StateObject var viewModel = ViewModel()
        var body: some View {
            VStack(alignment: .leading) {
                LazyVGrid(columns: gridItems) {
                    ForEach(viewModel.rankings) { user in
                        ProfileComponent(author: user)
                    }
                }
            }
            .onAppear {
                viewModel.getUserRanking()
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
