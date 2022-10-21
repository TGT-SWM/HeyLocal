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
    
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            VStack {
                ProfileComponent()
                    .padding()
                
                GeometryReader { geo in
                    VStack {
                        TopTabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                        
                        TabView(selection: $selectedTab, content: {
                            UserTravelOn()
                                .tag(0)
                            
                            UserOpinion()
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
}

struct UserTravelOn: View {
    @StateObject var viewModel = ProfileScreen.ViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.travelOns) { travelOn in
                    NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOn.id)) {
                        TravelOnComponent(travelOn: travelOn)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 3, trailing: 10))
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchTravelOns()
        }
    }
}

struct UserOpinion: View {
    @StateObject var viewModel = ProfileScreen.ViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.opinions) { opinion in
//                    NavigationLink(destination: OpinionDetailScreen(travelOnId: opinion., opinionId: opinion.id)) {
                        OpinionComponent(opinion: opinion)
                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 6, trailing: 10))
//                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchOpinions()
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
