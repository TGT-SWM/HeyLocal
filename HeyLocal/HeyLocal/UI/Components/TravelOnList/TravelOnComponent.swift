//
//  TravelOnComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnComponent: View {
    var travelOn: TravelOn

    var body: some View {
       
        ZStack {
            Rectangle()
                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.25)
             
            VStack {
                Text("\(travelOn.title)")
                Text("\(travelOn.region.state)")
                
                
                let printDate = travelOn.modifiedDate.components(separatedBy: "T")
                let yyyymmdd = printDate[0].components(separatedBy: "-")
                Text("\(yyyymmdd[0])년 \(yyyymmdd[1])월 \(yyyymmdd[2])일")
                
                HStack {
                    WebImage(url: travelOn.user.imageUrl)
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .cornerRadius(.infinity)
                    
                    Text(travelOn.user.nickname)
                    
                }
                
                Text("조회수 : \(travelOn.views)")
                Text("답변수 : \(travelOn.opinionQuantity)")
                
            }
        }
        .foregroundColor(Color.black)
    }
}
