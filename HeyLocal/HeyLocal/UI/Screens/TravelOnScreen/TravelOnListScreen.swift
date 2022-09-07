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
    
    @State private var withOpionions : Bool = false
    @State private var sortedType: SortType = .byDate
    
    @State var search: String = ""
    var body: some View {
        NavigationView {
            VStack{
                // 정렬
                Picker("정렬 방법", selection: $sortedType) {
                    ForEach(SortType.allCases) { s in
                        switch s {
                        case .byDate:
                            Text("최신순")
                            
                        case .byViews:
                            Text("조회순")
                            
                        case .byComments:
                            Text("답변 많은 순")
                        }
                    }
                }
                
                // 검색
                SearchBar("검색", text: $search)
                
                // Toggle
                HStack(spacing: 0) {
                    CheckedValue(value: false, label: "지역" )
                    
                    CheckedValued(value: $withOpionions, label: "답변 있는 것만")
                        .padding()
                    
                    CheckedValued(value: $withOpionions, label: "답변 없는 것만")
                }
                
                ZStack {
                    // TravelOn List 출력
                    ScrollView {
                        TravelOnList(sortBy: sortedType.rawValue)
                    }
                    
                    // 글쓰기 Floating Button
                    NavigationLink(destination: TravelOnReviseScreen()) {
                        Text("+")
                    }
                    .buttonStyle(WriteButtonStyle())
                    .frame(height: ScreenSize.height * 0.6, alignment: .bottom)
                    .padding()
                    
                }
            }
        } // end of NavigationView
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    } // end of View
}

struct TravelOnListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnListScreen()
    }
}
