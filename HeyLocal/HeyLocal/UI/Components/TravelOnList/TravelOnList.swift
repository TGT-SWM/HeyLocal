//
//  TravelOnComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnList: View {
    @Binding var showCommentOnly: Bool
    @Binding var showNonCommentOnly: Bool
    @Binding var sortedType: Int
    @Binding var user_id: String
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            // 비어있는지 확인
            
            // 아니면 출력
            contentView
        }
        .padding()
        .onAppear() {
            viewModel.fetchTravelOns()
        }
    }
    
    var emptyView: some View {
        Text("여행 On이 존재하지 않습니다.")
    }
    
    var contentView: some View {
        VStack {
            ForEach(viewModel.jungin(user_id: user_id, showCommentOnly: showCommentOnly, showNonCommentOnly: showNonCommentOnly, sortedType: sortedType)) { travelOn in
                TravelOnComponent(travelOn: travelOn)
                    .padding()
            }
        }
    }
}

struct TravelOnComponent: View {
    var travelOn: TravelOn
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월 d일"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.25)
            
            VStack {
                Text(travelOn.title)
                Text(travelOn.region)
                
                Text("\(travelOn.uploadDate, formatter: dateFormatter)")
                
                HStack {
                    WebImage(url: travelOn.writer.imageURL)
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .cornerRadius(.infinity)
                    
                    Text(travelOn.writer.name)
                    
                }
                
                Text("조회수 : \(travelOn.numOfViews)")
                Text("답변수 : \(travelOn.numOfComments)")
                
            }
        }
    }
}

