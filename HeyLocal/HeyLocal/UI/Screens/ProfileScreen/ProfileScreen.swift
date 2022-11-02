//
//  MyProfileScreen.swift
//  HeyLocal
//  사용자 프로필 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileScreen: View {
    @Environment(\.displayTabBar) var displayTabBar
    @State private var selectedTab: Int = 0
    var showingTabBar: Bool = true
    
    let tabs: [String] = ["내가 쓴 여행On", "내 답변"]
    let otherTabs: [String] = ["작성한 여행On", "답변 목록"]
    
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            VStack {
                UserComponent()
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                
                GeometryReader { geo in
                    VStack {
                        /// 내 프로필
                        if showingTabBar {
                            TopTabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                        }
                        /// 상대방 프로필
                        else {
                            TopTabs(tabs: otherTabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                        }
                        
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
            .onAppear {
                displayTabBar(showingTabBar)
            }
            .navigationBarTitle("", displayMode: .automatic)
            .navigationBarHidden(true)
        }
    }
}

struct UserTravelOn: View {
    @StateObject var viewModel = ProfileScreen.ViewModel()
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.travelOns) { travelOn in
                    NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOn.id)) {
                        TravelOnComponent(travelOn: travelOn)
                            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                    }
                }
                
                if !viewModel.travelOnisEnd {
                    ProgressView()
                        .onAppear {
                            viewModel.fetchTravelOns()
                        }
                }
            }
        }
        .onAppear {
            viewModel.fetchTravelOns()
        }
    }
}

struct UserComponent: View {
    @StateObject var viewModel = ProfileScreen.ViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                ZStack() {
                    if viewModel.author.profileImgDownloadUrl == nil {
                        ZStack {
                            Circle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: 96, height: 96)
                                .shadow(color: Color("gray"), radius: 3)
                            
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("gray"))
                        }
                    }
                    else {
                        AsyncImage(url: URL(string: viewModel.author.profileImgDownloadUrl!)) { phash in
                            if let image = phash.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 96, height: 96)
                                    .shadow(color: Color("gray"), radius: 3)
                            }
                            else if phash.error != nil {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                        .frame(width: 96, height: 96)
                                        .shadow(color: Color("gray"), radius: 3)
                                    
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color("gray"))
                                }
                            }
                            else {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                        .frame(width: 96, height: 96)
                                        .shadow(color: Color("gray"), radius: 3)
                                    
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color("gray"))
                                }
                            }
                        }
                    }
                    
                    
                    HStack{
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            // 프로필 설정화면으로 이동
                            NavigationLink(destination: ProfileSettingScreen()) {
                                Image("ios-settings")
                                    .resizable()
                                    .frame(width: 21, height: 21)
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                            
                            Spacer()
                            
                            // 프로필 수정화면으로 이동
                            NavigationLink(destination: ProfileReviseScreen()) {
                                HStack {
                                    Image("edit-pencil_yellow")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                    
                                    Spacer()
                                        .frame(width: 2)
                                    
                                    Text("편집하기")
                                        .underline()
                                        .font(.system(size: 12))
                                        .foregroundColor(Color("orange"))
                                }
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                        }
                        
                    }
                    .padding()
                }
                .frame(height: 96)
                
                Spacer()
                    .frame(height: 15)
                
                Text("\(regionNameFormatter(region: viewModel.author.activityRegion!))")
                    .font(.system(size: 12))
                
                Spacer()
                    .frame(height: 3)
                
                Text("\(viewModel.author.nickname)")
                    .font(.system(size: 16))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                
                Text("\(viewModel.author.introduce!)")
                    .font(.system(size: 12))
                    .foregroundColor(Color("gray"))
                
                Spacer()
                    .frame(height: 30)
            }
            
            Group {
                HStack {
                    Spacer()
                    // knowHow
                    VStack(alignment: .center) {
                        Text("\(viewModel.author.knowHow!)")
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                        
                        Text("내 노하우")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                    }
                    
                    Spacer()
                    
                    // Ranking
                    VStack(alignment: .center) {
                        Text("\(viewModel.author.ranking!)")
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                        
                        Text("내 랭킹")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                    }
                    
                    Spacer()
                    
                    // Opinion
                    VStack(alignment: .center) {
                        Text("\(viewModel.author.acceptedOpinionCount!)")
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                        
                        Text("채택 답변")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.getUserProfile(userId: 2)
        }
    }
}

struct UserOpinion: View {
    @StateObject var viewModel = ProfileScreen.ViewModel()
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.opinions) { opinion in
                    NavigationLink(destination: OpinionDetailScreen(travelOnId: opinion.travelOnId!, opinionId: opinion.id)) {
                        OpinionComponent(opinion: opinion)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                    }
                }
                
                if !viewModel.opinionIsEnd {
                    ProgressView()
                        .onAppear {
                            viewModel.fetchOpinions()
                        }
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
