//
//  OpinionComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionComponent: View {
    var opinion: Opinion
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                    .cornerRadius(10.0)
                    .frame(width: 100, height: 100)
                
                ZStack {
                    Rectangle()
                        .fill(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255))
                        .cornerRadius(radius: 20.0, corners: [.bottomLeft, .bottomRight])
                        .opacity(0.5)
                        .frame(width: 100, height: 24)
                    
                    HStack {
                        Image("pin_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                        
                        Text("\(regionNameFormatter(region: opinion.place!.region!))")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
                    }
                }
            } // ZStack
            
            Spacer()
                .frame(width: 20)
            
            VStack(alignment: .leading) {
                // 장소 이름
                Text("\(opinion.place!.name!)")
                    .font(.system(size: 14))
                
                // 사용자 정보
                HStack(alignment: .center) {
                    Circle()
                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        .frame(width: 20, height: 20)
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Text("\(opinion.author!.nickname)")
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    
                    Spacer()
                        .frame(width: 3)
                    
                    Text("(채택 \(opinion.countAccept!)건)")
                }
                .font(.system(size: 12))
            }
            .padding(EdgeInsets(top: 7, leading: 0, bottom: 0, trailing: 0))
        }
        .frame(width: 360)
    }
}
