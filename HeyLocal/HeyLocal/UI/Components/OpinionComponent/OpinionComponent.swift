//
//  OpinionComponent.swift
//  HeyLocal
//  답변 컴포넌트
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionComponent: View {
    var opinion: Opinion
    
    var body: some View {
        HStack(alignment: .top) {
            if opinion.generalImgDownloadImgUrl.isEmpty {
                if opinion.place.thumbnailUrl != nil {
                    AsyncImage(url: URL(string: opinion.place.thumbnailUrl!)) { phash in
                        if let image = phash.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(10.0)
                        }
                        else {
                            Rectangle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .cornerRadius(10.0)
                                .frame(width: 100, height: 100)
                        }
                    }
                } else {
                    Rectangle()
                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        .cornerRadius(10.0)
                        .frame(width: 100, height: 100)
                }
            }
            else {
                AsyncImage(url: URL(string: opinion.generalImgDownloadImgUrl[0])) { phash in
                    if let image = phash.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(10.0)
                    }
                    else {
                        Rectangle()
                            .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                            .cornerRadius(10.0)
                            .frame(width: 100, height: 100)
                    }
                }
            }
            Spacer()
                .frame(width: 15)
            
            VStack(alignment: .leading) {
                /// 장소 이름
                Text("\(opinion.place.name)")
                    .font(.system(size: 16))
                
                Spacer()
                    .frame(height: 7)
                
                /// 장소 지역
                if opinion.place.roadAddress != "" {
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(opinion.place.roadAddress)")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                    }
                }
                else if opinion.place.address != "" {
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(opinion.place.address)")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                    }
                }
                
                Spacer()
                
                /// 작성자
                HStack {
                    Text("\(opinion.author.nickname)")
                    
                    Spacer()
                        .frame(width: 3)
                    
                    Text("(채택 \(opinion.author.acceptedOpinionCount!)건)")
                }
                .font(.system(size: 12))
                .foregroundColor(Color("gray"))
            }
            .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))

            Spacer()
        }
        .foregroundColor(Color.black)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}
