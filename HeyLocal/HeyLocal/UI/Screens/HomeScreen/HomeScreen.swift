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
    
    var alarmButton: some View {
        NavigationLink(destination: EmptyView()) {
            Image(systemName: "bell")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .foregroundColor(Color.black)
        }
    }
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // TODO: 아티클
                    Group {
                        Article()
                    }
                    
                    // HOT한 장소
                    Group {
                        Spacer()
                            .frame(height: 210)
                        
                        Text("요즘 HOT한 장소🔥")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                        HotPlace()
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
                        
                        Spacer()
                            .frame(height: 20)
                        
                    }
                    
                    // 여행On
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
            .navigationBarItems(trailing: alarmButton)
//            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            
        }
    }
}

// MARK: - Article
extension HomeScreen {
    struct Article: View {
        let imageLink: [String] = ["https://blog.kakaocdn.net/dn/o1KIw/btqu9mflPY6/rGk1mM3iugV1c6jj9Z3E80/img.jpg", "https://cdn.epnc.co.kr/news/photo/202001/93682_85075_3859.jpg", "https://www.agoda.com/wp-content/uploads/2020/12/E-WORLD-83-Tower-places-to-visit-in-daegu-south-korea.jpg"]
        let textArray: [String] = ["떠나요, 제주로", "부산 밤바다", "대구가 궁금해요"]
        
        var body: some View {
            VStack {
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = 182
                    
                    TabView {
                        ForEach(0..<3) { idx in
                            ZStack(alignment: .leading) {
                                // 이미지
                                AsyncImage(url: URL(string: imageLink[idx])) { phash in
                                    if let image = phash.image {
                                        ZStack {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: width, height: CGFloat(height))
                                        }
                                        
                                    }
                                    else if phash.error != nil {
                                        Text("")
                                    }
                                    else {
                                        Text("")
                                    }
                                }
                                
                                // 글
                                Text("\(textArray[idx])")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(width: width, height: CGFloat(height))
                }
            }
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
