//
//  ProfileComponent.swift
//  HeyLocal
//  프로필 화면 컴포넌트
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileComponent: View {
    @State var author: Author
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                ZStack() {
                    // TODO: 사용자 프로필
                    Circle()
                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        .frame(width: 96, height: 96)
                        .shadow(color: Color("gray"), radius: 3)
                    
                    
                    HStack{
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            // TODO: 프로필 설정화면으로 이동
                            NavigationLink(destination: EmptyView()) {
                                Image("setting_icon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                            
                            Spacer()
                            
                            // TODO: 프로필 수정화면으로 이동
                            NavigationLink(destination: EmptyView()) {
                                HStack {
                                    Image("pencil_orange_icon")
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
                }
                .frame(height: 96)
                
                Spacer()
                    .frame(height: 15)
                
                Text("\(regionNameFormatter(region: author.activityRegion))")
                    .font(.system(size: 12))
                
                Spacer()
                    .frame(height: 3)
                
                Text("\(author.nickname)")
                    .font(.system(size: 16))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                
                Text("\(author.introduce)")
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
                        Text("\(author.knowHow!)")
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                        
                        Text("내 노하우")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                    }
                    
                    Spacer()
                    
                    // Ranking
                    VStack(alignment: .center) {
                        Text("\(author.ranking!)")
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                        
                        Text("내 랭킹")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                    }
                    
                    Spacer()
                    
                    // Opinion
                    VStack(alignment: .center) {
                        Text("\(author.acceptedOpinionCount!)")
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
        .padding()
    }
}

struct ProfileComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileComponent(author: Author(userId: 0,
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
