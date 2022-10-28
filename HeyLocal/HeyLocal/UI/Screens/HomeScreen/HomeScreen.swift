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
            .navigationViewStyle(StackNavigationViewStyle())
            
        }
    }
}

// MARK: - Article
extension HomeScreen {
    struct Article: View {
        let imageLink: [String] = ["https://postfiles.pstatic.net/MjAyMjA5MTJfMjk5/MDAxNjYyOTU2Mjg2NDY5.FfTMyD4FSV-ooPxEGMON2gow3ILfTT4ijs_3aVERYZYg.ukQaBMf37JyfJxjx_dCSE8Cqe2MvRczKsziVZnrC998g.JPEG.leeja5139/1662944966705.jpg?type=w966", "https://postfiles.pstatic.net/MjAyMjA3MDZfMjIx/MDAxNjU3MDY3MjU0NzU4.3GmYfVz_sYzXPDDumlexvRTnNkpsBy-vEw5zv7OQuWUg.1tK3R3mWfxE70fdFKbNJpICtftdGBPEVlelvQb7r0Z0g.JPEG.leeja5139/20220608%EF%BC%BF132217%EF%BC%BF03%EF%BC%BFsaved.jpg?type=w966", "https://postfiles.pstatic.net/MjAyMjA3MTRfNTYg/MDAxNjU3NzYyMTY3NTgw.NXycV5T9PyOaM5lqpufNLsV--dJxAy3dRCnG_b1qQbcg.oBmo2RD9Ow2748GD44ag4oUjrn6fAeCjOoAn6cc2FXsg.JPEG.leeja5139/20220713%EF%BC%BF152002.jpg?type=w966"]
        let textArray: [String] = ["떠나요 나주\n사진찍기 좋은 곳으로", "경남 사천에서 즐기는\n가을여행 Best 8", "둘이 걸어요\n순창 편백숲길"]
        
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
                                
                                
                                Rectangle()
                                    .fill(.black)
                                    .frame(width: width, height: CGFloat(height))
                                    .opacity(0.3)
                                
                                // 글
                                Text("\(textArray[idx])")
                                    .lineLimit(2)
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
        @StateObject var viewModel = ViewModel()
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    ForEach(viewModel.rankings) { user in
                        ZStack {
                            ProfileComponent(author: user)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                        }
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
