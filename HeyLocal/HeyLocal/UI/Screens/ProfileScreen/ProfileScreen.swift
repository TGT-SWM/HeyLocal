//
//  MyProfileScreen.swift
//  HeyLocal
//  사용자 프로필 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileScreen: View {
    @State var navLinkActive: Bool = false
    @State private var selectedTab: Int = 0
    let tabs: [String] = ["내가 쓴 여행 On", "내 답변"]
    var author: Author
    
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            VStack {
                ProfileComponent(author: author)
                    .padding()
                
                GeometryReader { geo in
                    VStack {
                        TopTabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                        
                        TabView(selection: $selectedTab, content: {
                            travelOn
                                .tag(0)
                            
                            opinion
                                .tag(1)
                        })
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
                .ignoresSafeArea()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // 작성한 여행On
    var travelOn: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.travelOns) { travelOn in
                    NavigationLink(destination: EmptyView()) {
                        TravelOnComponent(travelOn: travelOn)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    }
                }
            }
        }
    }
    
    // 작성한 답변
    var opinion: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.opinions) { opinion in
                    OpinionComponent(opinion: opinion)
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                }
            }
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(author: Author(userId: 0,
                                       nickname: "김현지",
                                       activityRegion: Region(id: 259, state: "부산광역시"),
                                       introduce: "안녕하세요, 부산사는 김현지입니다 ^0^*",
                                       profileImgDownloadUrl: "",
                                       knowHow: 500,
                                       ranking: 350,
                                       acceptedOpinionCount: 5,
                                       totalOpinionCount: 0))
    }
}
