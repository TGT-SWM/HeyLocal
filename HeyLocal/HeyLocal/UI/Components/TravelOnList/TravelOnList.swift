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
    
    @StateObject var viewModel = ViewModel()
    
    var filteredTravelOns: [TravelOn] {
        var resultTravelOns: [TravelOn] = viewModel.travelOns
        
        if showCommentOnly {
            resultTravelOns = viewModel.travelOns.filter { travelon in
                (travelon.numOfComments > 0)
            }
        }
        
        else if showNonCommentOnly {
            resultTravelOns = viewModel.travelOns.filter { travelon in
                (travelon.numOfComments == 0)
            }
        }
        
        return resultTravelOns
    }
    
    var body: some View {
        VStack {
            ForEach(filteredTravelOns) { travelOn in
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
//
//struct TravelOnList_Previews: PreviewProvider {
//    @State var showComm: Bool = false
//
//    static var previews: some View {
//        TravelOnList(showCommentOnly: $showComm)
//    }
//}
