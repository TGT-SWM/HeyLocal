//
//  RankingProfileComponent.swift
//  HeyLocal
//  프로필 컴포넌트 (User 랭킹)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct RankingProfileComponent: View {
    var author: Author
    var body: some View {
        VStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                if author.profileImgDownloadUrl == nil {
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                            .cornerRadius(10.0)
                            .frame(width: 109, height: 109)
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("gray"))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    }
                }
                else {
                    AsyncImage(url: URL(string: author.profileImgDownloadUrl!)) { phash in
                        if let image = phash.image {
                            ZStack {
                                image
                                    .resizable()
                                    .frame(width: 109, height: 109)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(10.0)
                                    .shadow(color: Color("gray"), radius: 3)
                                
                                
                                Rectangle()
                                    .fill(Color.black)
                                    .cornerRadius(10.0)
                                    .frame(width: 109, height: 109)
                                    .opacity(0.3)
                                
                            }
                            
                        }
                        else if phash.error != nil {
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                    .cornerRadius(10.0)
                                    .frame(width: 109, height: 109)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("gray"))
                            }
                        }
                        else {
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                    .cornerRadius(10.0)
                                    .frame(width: 109, height: 109)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("gray"))
                            }
                        }
                    }
                }
                
                VStack {
                    if author.activityRegion != nil {
                        Text("\(regionNameFormatter(region: author.activityRegion!))")
                            .font(.system(size: 12))
                    }
                    
                    Text("\(author.nickname)")
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(height: 5)
                }
                .foregroundColor(Color.white)
            }
            
            Spacer()
                .frame(height: 10)
            
            // 답변 수
            HStack {
                Image("message-text")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 16, height: 16)
                
                Spacer()
                    .frame(width: 3)
                
                Text("답변수")
                
                Spacer()
                    .frame(width: 3)
                
                Text("\(author.totalOpinionCount!)")
            }
            .font(.system(size: 12))
            .foregroundColor(Color("gray"))
            
            Spacer()
                .frame(height: 3)
            
            // 채택 수
            HStack {
                Image("heart")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 16, height: 16)
                
                Spacer()
                    .frame(width: 3)
                
                Text("채택수")
                
                Spacer()
                    .frame(width: 3)
                
                Text("\(author.acceptedOpinionCount!)")
            }
            .font(.system(size: 12))
            .foregroundColor(Color("gray"))
        }
        .onAppear {
            
        }
    }
}

struct RankingProfileComponent_Previews: PreviewProvider {
    static var previews: some View {
        RankingProfileComponent(author: Author(userId: 2,
                                        nickname: "김현지",
                                        activityRegion: Region(id: 259, state: "부산광역시"),
                                        introduce: "",
                                        profileImgDownloadUrl: nil,
                                        knowHow: 1,
                                        ranking: 1,
                                        acceptedOpinionCount: 845,
                                        totalOpinionCount: 189))
    }
}
