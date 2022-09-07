//
//  TravelOnComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnList: View {
    @StateObject var viewModel = ViewModel()
    
    @State var lastItemId: Int? = nil
    @State var pageSize: Int = 10
    @State var regionId: Int? = nil
    @State var sortBy: String = "DATE"
    @State var withOpinions: Bool? = nil
    
    var body: some View {
        VStack {
            ForEach(viewModel.travelOns) { travelOn in
                TravelOnComponent(travelOn: travelOn)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchTravelOn(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy, withOpinions: withOpinions)
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
                Text("\(travelOn.region.city)  \(travelOn.region.state)")
                
                Text("\(travelOn.modifiedDate, formatter: dateFormatter)")
                
                HStack {
                    WebImage(url: travelOn.userProfile.imageURL)
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


struct TravelOnList_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnList()
    }
}
