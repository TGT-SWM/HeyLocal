//
//  TravelOnComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import Combine

struct TravelOnList: View {
    @StateObject var viewModel = ViewModel()
    
    @State var lastItemId: Int? = nil
    @State var pageSize: Int = 10
    @State var regionId: Int? = nil
    @Binding var sortBy: SortType
    @Binding var withOpinions: Bool
    @Binding var withNonOpinions: Bool

    @ViewBuilder
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        switch sortBy{
        case .byDate:
            changeView
        case .byViews:
            changeView
        case .byComments:
            changeView
        }
        
        switch withOpinions{
        case false:
            changeView
        case true:
            changeView
        }
        
        switch withNonOpinions{
        case false:
            changeView
        case true:
            changeView
        }
    }
}


private extension TravelOnList {
    var changeView: some View {
        VStack {
            ForEach(viewModel.travelOns) { travelOn in
                TravelOnComponent(travelOn: travelOn)
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchTravelOn(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
        }
    }
}

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
                    WebImage(url: travelOn.userProfile.imageUrl)
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .cornerRadius(.infinity)
                    
                    Text(travelOn.userProfile.nickname)
                    
                }
                
                Text("조회수 : \(travelOn.views)")
                Text("답변수 : \(travelOn.opinionQuantity)")
                
            }
        }
    }
}
