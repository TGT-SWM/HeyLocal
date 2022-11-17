//
//  HomeScreen.swift
//  HeyLocal
//	홈 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.displayTabBar) var displayTabBar
    @StateObject var viewModel = ViewModel()
    
    var alarmButton: some View {
        NavigationLink(destination: EmptyView()) {
            Image(systemName: "bell")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(Color.black)
        }
    }
    let imageLink: [String] = ["https://postfiles.pstatic.net/MjAyMjA5MTJfMjk5/MDAxNjYyOTU2Mjg2NDY5.FfTMyD4FSV-ooPxEGMON2gow3ILfTT4ijs_3aVERYZYg.ukQaBMf37JyfJxjx_dCSE8Cqe2MvRczKsziVZnrC998g.JPEG.leeja5139/1662944966705.jpg?type=w966", "https://postfiles.pstatic.net/MjAyMjA3MDZfMjIx/MDAxNjU3MDY3MjU0NzU4.3GmYfVz_sYzXPDDumlexvRTnNkpsBy-vEw5zv7OQuWUg.1tK3R3mWfxE70fdFKbNJpICtftdGBPEVlelvQb7r0Z0g.JPEG.leeja5139/20220608%EF%BC%BF132217%EF%BC%BF03%EF%BC%BFsaved.jpg?type=w966", "https://postfiles.pstatic.net/MjAyMjA3MTRfNTYg/MDAxNjU3NzYyMTY3NTgw.NXycV5T9PyOaM5lqpufNLsV--dJxAy3dRCnG_b1qQbcg.oBmo2RD9Ow2748GD44ag4oUjrn6fAeCjOoAn6cc2FXsg.JPEG.leeja5139/20220713%EF%BC%BF152002.jpg?type=w966"]
    let textArray: [String] = ["떠나요 나주\n사진찍기 좋은 곳으로", "경남 사천에서 즐기는\n가을여행 Best 8", "둘이 걸어요\n순창 편백숲길"]
    let blogLink: [String] = ["https://blog.naver.com/leeja5139/222872754954", "https://blog.naver.com/leeja5139/222866369185", "https://blog.naver.com/leeja5139/222876263557"]
    @State var blogUrl: String = ""
    @State var showingWebView: Bool = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
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
                                    }.onTapGesture {
                                        blogUrl = blogLink[idx]
                                        showingWebView.toggle()
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
                    
                    Spacer()
                        .frame(height: 170)
                    
                    HotPlace()
                    
                    RecentTravelOn()
                    
                    Ranking()
                    
                    if showingWebView {
                        NavigationLink(destination: WebViewScreen(url: blogUrl), isActive: $showingWebView) {
                            Text("")
                        }
                    }
                }
            }
            .onAppear {
                displayTabBar(true)
            }
            .background(Color("lightGray"))
			.navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
				leading: Image("login-symbol")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 0))
//				,trailing: alarmButton // TODO: 알림 기능
			)
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
                
            }
            .background(.white)
        }
    }
}


// MARK: - Hot한 장소
extension HomeScreen {
    struct HotPlace: View {
        @StateObject var viewModel = ViewModel()
        var body: some View {
            VStack(alignment: .leading) {
                Text("요즘 HOT한 장소🔥")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.hotplaces) { place in
                            HotPlaceComponent(place: place)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 0))
                        }
                    }
                }
                .ignoresSafeArea(.all)
            }
            .background(.white)
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
            VStack(alignment: .leading) {
                Text("현지인의 추천이 궁금해요😮")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                
                ForEach(viewModel.travelOns) { travelOn in
                    NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOn.id)){
                        TravelOnComponent(travelOn: travelOn)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    }
                }
            }
            .background(.white)
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
                    Text("노하우 랭킹👑")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    NavigationLink(destination: UserRankingScreen()) {
                        Text("더보기")
                            .underline()
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                    }
                }
                
                
                HStack {
                    ForEach(viewModel.rankings) { ranking in
                        ZStack(alignment: .topLeading) {
                            RankingProfileComponent(author: ranking)
                            
                            if ranking.id == viewModel.rankings[0].id {
                                Image("Rank1")
                                    .resizable()
                                    .frame(width: 19, height: 26)
                                    .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 0))
                            }
                            
                            else if ranking.id == viewModel.rankings[1].id {
                                Image("Rank2")
                                    .resizable()
                                    .frame(width: 19, height: 26)
                                    .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 0))
                            }
                            
                            else if ranking.id == viewModel.rankings[2].id {
                                Image("Rank3")
                                    .resizable()
                                    .frame(width: 19, height: 26)
                                    .padding(EdgeInsets(top: 0, leading: 9, bottom: 0, trailing: 0))
                            }
                        }
                        
                        if ranking.id != viewModel.rankings[viewModel.rankings.count - 1].id {
                            Spacer()
                        }
                    }
                }
                
            }
            .padding()
            .background(.white)
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
