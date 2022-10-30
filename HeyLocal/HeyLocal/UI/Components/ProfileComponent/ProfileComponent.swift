//
//  ProfileComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileComponent: View {
    var author: Author
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                /// 프로필 사진 · 지역 · 이름
                HStack {
                    // 프로필 사진
                    if author.profileImgDownloadUrl == nil {
                        ZStack {
                            Circle()
                                .fill(Color("lightGray"))
                                .frame(width: 48, height: 48)
                                .shadow(color: Color("gray"), radius: 1)
                            
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("gray"))
                        }
                    }
                    else {
                        AsyncImage(url: URL(string: author.profileImgDownloadUrl!)) { phash in
                            if let image = phash.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 48, height: 48)
                                    .shadow(color: Color("gray"), radius: 1)
                            }
                            else {
                                ZStack {
                                    Circle()
                                        .fill(Color("lightGray"))
                                        .frame(width: 48, height: 48)
                                        .shadow(color: Color("gray"), radius: 1)
                                    
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color("gray"))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    VStack(alignment: .leading) {
                        Text("\(regionNameFormatter(region: author.activityRegion!))")
                            .font(.system(size: 12))
                        
                        // TODO: 프로필화면으로 이동
                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                Text("\(author.nickname)")
                                    .font(.system(size: 16))
                                    
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 12, height: 12)
                            }
                            .foregroundColor(.black)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                /// 답변수 · 채탤수
                VStack {
                    HStack {
                        Image("message-text")
                            .resizable()
                            .frame(width: 13, height: 13)
                        
                        Text("답변수")
                        
                        Text("\(author.totalOpinionCount!)")
                    }
                    
                    HStack {
                        Image("heart")
                            .resizable()
                            .frame(width: 13, height: 13)
                        
                        Text("채택수")
                        
                        Text("\(author.acceptedOpinionCount!)")
                    }
                }
                .foregroundColor(Color("gray"))
                .font(.system(size: 12))
                .padding()
            }
            
            /// 소개
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color(red: 248/255, green: 248/255, blue: 248/255))
                    .frame(width: ScreenSize.width, height: 64)
                
                Text("\(author.introduce!)")
                    .font(.system(size: 12))
                    .foregroundColor(Color("gray"))
                    .padding()
                
            }
        }
    }
}
