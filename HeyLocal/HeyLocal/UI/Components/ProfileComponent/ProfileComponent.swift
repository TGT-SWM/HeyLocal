//
//  ProfileComponent.swift
//  HeyLocal
//  프로필 화면 컴포넌트
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileComponent: View {
    
    @StateObject var viewModel = ProfileScreen.ViewModel()
    var body: some View {
        VStack(alignment: .center) {
            Group {
                ZStack() {
                    AsyncImage(url: URL(string: viewModel.author.profileImgDownloadUrl)) { phash in
                        if let image = phash.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 96, height: 96)
                                .shadow(color: Color("gray"), radius: 3)
                        }
                        else if phash.error != nil {
                            Image(systemName: "exclamationmark.icloud.fill")
                                .resizable()
                                .foregroundColor(Color("gray"))
                                .frame(width: 96, height: 96)
                        }
                        else {
                            Circle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: 96, height: 96)
                                .shadow(color: Color("gray"), radius: 3)
                        }
                    }
                    
                    
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
                            NavigationLink(destination: ProfileReviseScreen()) {
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
                
                Text("\(regionNameFormatter(region: viewModel.author.activityRegion))")
                    .font(.system(size: 12))
                
                Spacer()
                    .frame(height: 3)
                
                Text("\(viewModel.author.nickname)")
                    .font(.system(size: 16))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                
                Text("\(viewModel.author.introduce)")
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

struct ProfileComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileComponent()
    }
}
