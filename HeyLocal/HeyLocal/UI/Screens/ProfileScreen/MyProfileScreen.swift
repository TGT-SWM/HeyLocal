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
    
    var body: some View {
        NavigationView {
            VStack {
                MyProfileComponent()
                
                GeometryReader { geo in
                    VStack {
                        TopTabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                        
                        TabView(selection: $selectedTab, content: {
                            SignInScreen()
                                .tag(0)
                            
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

struct MyProfileComponent: View {
    var body: some View {
        ZStack {
            Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
            
            VStack {
                Button(action: {}) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 15, height: 15)
                }
                
                HStack {
                    WebImage(url: "https://cdna.artstation.com/p/assets/images/images/034/457/374/large/shin-min-jeong-.jpg?1612345113")
                        .scaledToFill()
                        .frame(width: ScreenSize.width * 0.2, height: ScreenSize.width * 0.2)
                        .clipped()
                        .cornerRadius(.infinity)
                    
                    
                    
                    VStack {
                        HStack {
                            Text("김현지")
                                .font(.system(size: 23))
                                .fontWeight(.bold)
                            
                            // 수정버튼
                            Button(action: {}) {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .foregroundColor(Color.black)
                                    .frame(width: 15, height: 15)
                            }
                        }
                        
                        HStack {
                            Text("내 노하우")
                            Text("500하우")
                        }
                        
                        HStack {
                            Text("내 랭킹")
                            Text("350위")
                        }
                        
                    }
                }
            }
        }
        .frame(height: ScreenSize.height * 0.2)
    }
}

struct MyProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileScreen()
    }
}
