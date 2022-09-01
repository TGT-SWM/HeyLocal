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
                ProfileComponent()
                
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

struct MyProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileScreen()
    }
}
