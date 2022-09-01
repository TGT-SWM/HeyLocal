//
//  MyProfileScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct MyProfileScreen: View {
    @State private var selectedTab: Int = 0
    let tabs: [String] = ["내가 쓴 여행 On", "내 답변"]
    
    @State private var showCommentOnly = false
    @State private var showNonCommentOnly = false
    @State private var sortedType: Int = 0
    @State private var user_id: String = "kimhyeonji"
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    ProfileComponent()
                    
                    HStack(alignment: .top){
                        NavigationLink(destination: SettingScreen(), label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .foregroundColor(Color.black)
                                .frame(width: 15, height: 15)
                        })
                        
                        NavigationLink(destination: ProfileReviseScreen(), label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .foregroundColor(Color.black)
                                .frame(width: 15, height: 15)
                        })
                    }
                }
                
                GeometryReader { geo in
                    VStack {
                        TopTabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                        
                        TabView(selection: $selectedTab, content: {
                            ScrollView {
                                TravelOnList(showCommentOnly: $showCommentOnly, showNonCommentOnly: $showNonCommentOnly, sortedType: $sortedType, user_id: $user_id)
                                    .tag(0)
                            }
                            
                            
                            SignUpScreen()
                                .tag(1)
                        })
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
                }
            }
        }

    }
}

struct MyProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileScreen()
    }
}
