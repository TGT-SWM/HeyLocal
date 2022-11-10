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
                HStack(alignment: .center) {
                    // 프로필 사진
                    if author.profileImgDownloadUrl == nil {
                        ZStack {
                            Circle()
                                .fill(Color("lightGray"))
                                .frame(width: 48, height: 48)
                                .shadow(color: Color("gray"), radius: 1)
                            
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
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
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color("gray"))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    VStack(alignment: .leading) {
						if let activityRegion = author.activityRegion {
							Text("\(regionNameFormatter(region: activityRegion))")
								.font(.system(size: 12))
						}
                        
                        Spacer()
                            .frame(height: 7)
                        
                        // 프로필화면으로 이동
                        NavigationLink(destination: ProfileScreen(userId: author.id, showingTab: false)) {
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
                
                /// 답변수 · 채택수
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image("message-text")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        
                        Spacer()
                            .frame(width: 5)
                        
                        Text("답변수")
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(author.totalOpinionCount!)")
                    }
                    
                    HStack(alignment: .center) {
                        Image("heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                        
                        Spacer()
                            .frame(width: 5)
                        
                        Text("채택수")
                        
                        Spacer()
                            .frame(width: 3)
                        
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
                
				if let introduce = author.introduce {
					Text("\(introduce)")
						.font(.system(size: 12))
						.foregroundColor(Color("gray"))
						.padding()
				}
            }
        }
        .background(.white)
    }
}
