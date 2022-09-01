//
//  ProfileComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileComponent: View {
    var body: some View {
        ZStack {
            Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
            
            VStack {
//                    NavigationLink(destination: SettingScreen(), label: {
//                        Image(systemName: "gearshape")
//                            .resizable()
//                            .foregroundColor(Color.black)
//                            .frame(width: 15, height: 15)
//                    })
//                    
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
//                                NavigationLink(destination: ProfileReviseScreen(), label: {
//                                    Image(systemName: "pencil")
//                                        .resizable()
//                                        .foregroundColor(Color.black)
//                                        .frame(width: 15, height: 15)
//                                })
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

struct ProfileComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileComponent()
    }
}
