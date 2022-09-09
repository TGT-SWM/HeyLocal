//
//  TravelOnListScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnListScreen: View {
    enum SortType: String, CaseIterable, Identifiable {
        case byDate = "DATE"
        case byViews = "VIEWS"
        case byComments = "OPINIONS"
        
        var id: String { self.rawValue }
    }
    
    @State var lastItemId: Int? = nil
    @State var pageSize: Int = 5
    @State var regionId: Int? = nil
    @State var sortType: SortType = .byDate
    @State var withOpinions : Bool = false
    @State var withNonOpinions : Bool = false
    
    @State var search: String = ""
    @StateObject var viewModel = ViewModel()
    @State private var action: Int? = 0
    var body: some View {
        VStack{
            
            
            NavigationView {
                VStack {
                    // sort By
                    Picker("sort By", selection: $sortType) {
                        ForEach(SortType.allCases, id:\.id) { value in
                            switch value {
                            case .byDate:
                                Text("최신순")
                                    .tag(value)
                                
                            case .byViews:
                                Text("조회순")
                                    .tag(value)
                                
                            case .byComments:
                                Text("답변순")
                                    .tag(value)
                            }
                        }
                    }.onChange(of: sortType, perform: { value in
                        viewModel.fetchTravelOnList(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: value.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
                    })
                    
                    // Search Bar
                    SearchBar("검색", text: $search)
                    
                    // filter By
                    HStack(spacing: 0) {
                        CheckedValue(value: false, label: "지역" )
                        
                        Button(action: {
                            withOpinions.toggle()
                            viewModel.fetchTravelOnList(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortType.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
                            
                        }) {
                            Text("답변 있는 것만")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $withOpinions))
                            .padding()
                        
                        Button(action: {
                            withNonOpinions.toggle()
                            viewModel.fetchTravelOnList(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortType.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
                        }) {
                            Text("답변 없는 것만")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $withNonOpinions))
                    }
                    
                    ZStack {
                        // content
                        ScrollView {
                            VStack {
                                ForEach(viewModel.travelOns) { travelOn in
                                    NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOn.id, travelOnDetail: viewModel.travelOn)){
                                        TravelOnComponent(travelOn: travelOn)
                                            .padding()
                                    }
//                                    .simultaneousGesture(TapGesture().onEnded({
//                                        self.fetchTravelOnDetail(travelOnId: travelOn.id)
//                                    }))
                                }
                            }
                        }
                        
                        // write Button
                        NavigationLink(destination: TravelOnReviseScreen()) {
                            Text("+")
                        }
                        .buttonStyle(WriteButtonStyle())
                        .frame(height: ScreenSize.height * 0.6, alignment: .bottom)
                        .padding()
                    }
                }
            }
            
        }
    }
        
    
}

struct TravelOnListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnListScreen()
    }
}
