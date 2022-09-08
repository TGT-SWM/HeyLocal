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
            }
            
            // Search Bar
            SearchBar("검색", text: $search)
            
            // filter By
            HStack(spacing: 0) {
                CheckedValue(value: false, label: "지역" )
                
                CheckedValued(value: $withOpinions, label: "답변 있는 것만")
                    .padding()
                
                CheckedValued(value: $withNonOpinions, label: "답변 없는 것만")
            }
            
            ZStack {
                // content
                ScrollView {
                    TravelOnList(sortBy: $sortType, withOpinions: $withOpinions, withNonOpinions: $withNonOpinions)
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
