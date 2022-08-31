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
    
    @StateObject var viewModel = ViewModel()
    
    // TravleOn 필터링
    var filteredTravelOns: [TravelOn] {
        var resultTravelOns: [TravelOn] = viewModel.travelOns
        
        // 답변 있는 것만 보기
        if showCommentOnly {
            resultTravelOns = viewModel.travelOns.filter { travelon in
                (travelon.numOfComments > 0)
            }
        }
        
        // 답변 없는 것만 보기
        else if showNonCommentOnly {
            resultTravelOns = viewModel.travelOns.filter { travelon in
                (travelon.numOfComments == 0)
            }
        }
        return resultTravelOns
    }
    
    // TravelOn 정렬
    var sortedTravelOns: [TravelOn] {
        var resultTravelOns: [TravelOn] = filteredTravelOns
        
        // 최신순
        if sortedType == 0 {
            resultTravelOns = filteredTravelOns.sorted(by: {$0.uploadDate > $1.uploadDate})
        }
        
        // 조회순
        else if sortedType == 1 {
            resultTravelOns = filteredTravelOns.sorted(by: {$0.numOfViews > $1.numOfViews})
        }
        
        // 답변 많은 순
        else {
            resultTravelOns = filteredTravelOns.sorted(by: {$0.numOfComments > $1.numOfComments})
        }
        return resultTravelOns
    }
    
    var body: some View {
        VStack {
            ForEach(sortedTravelOns) { travelOn in
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
