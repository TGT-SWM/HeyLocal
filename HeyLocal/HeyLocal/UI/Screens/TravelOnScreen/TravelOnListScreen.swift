//
//  TravelOnListScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

enum SortType: String, CaseIterable, Identifiable {
    case byDate = "DATE"
    case byViews = "VIEWS"
    case byComments = "OPINIONS"
    
    var id: String { self.rawValue }
}

struct TravelOnListScreen: View {
    @State var sortType: SortType = .byDate
    @State var regionId: Int? = nil
    @State var withOpinions : Bool = false
    @State var withNonOpinions : Bool = false
    @State var search: String = ""

    @StateObject var viewModel = ViewModel()
    var body: some View {
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
                viewModel.fetchTravelOnList(lastItemId: nil, pageSize: 3, regionId: nil, sortBy: value.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
            })
            
            // Search Bar
            SearchBar("검색", text: $search)
            
            // filter By
            HStack(spacing: 0) {
                CheckedValue(value: false, label: "지역" )
                
                Button(action: {
                    withOpinions.toggle()
                    viewModel.fetchTravelOnList(lastItemId: nil, pageSize: 3, regionId: nil, sortBy: sortType.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
                    
                }) {
                    Text("답변 있는 것만")
                }
                .buttonStyle(ToggleButtonStyle(value: $withOpinions))
                    .padding()
                
                Button(action: {
                    withNonOpinions.toggle()
                    viewModel.fetchTravelOnList(lastItemId: nil, pageSize: 3, regionId: nil, sortBy: sortType.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
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
                            TravelOnComponent(travelOn: travelOn)
                                .padding()
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

struct TravelOnListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnListScreen()
    }
}
