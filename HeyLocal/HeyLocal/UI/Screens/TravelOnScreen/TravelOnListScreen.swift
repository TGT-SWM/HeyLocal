//
//  TravelOnListScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

//TempTravelOnList
struct TempTravelOnList: View {
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
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar("검색", text: $search)
                
                // filter By
                HStack(spacing: 0) {
                    CheckedValue(value: false, label: "지역" )
                    
                    Button(action: {
                        withOpinions.toggle()
                        self.checkOpinions()
                        viewModel.fetchTravelOnList(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortType.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
                        
                    }) {
                        Text("답변 있는 것만")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $withOpinions))
                        .padding()
                    
                    Button(action: {
                        withNonOpinions.toggle()
                        self.checkOpinions()
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
                                NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOn.id)){
                                    TravelOnComponent(travelOn: travelOn)
                                        .padding()
                                }
                            }
                        }
                    }
                    
                    // write Button
                    NavigationLink(destination: TravelOnWriteScreen()) {
                        Text("+")
                    }
                    .buttonStyle(WriteButtonStyle())
                    .frame(height: ScreenSize.height * 0.5, alignment: .bottom)
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchTravelOnList(lastItemId: nil, pageSize: 5, regionId: nil, sortBy: "DATE", withOpinions: false, withNonOpinions: false)
        }
        .navigationTitle("여행On 리스트")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content:{
//                Menu {
//                    Picker("sort By", selection: $sortType) {
//                        ForEach(SortType.allCases, id:\.id) { value in
//                            switch value {
//                            case .byDate:
//                                Text("최신순")
//                                    .tag(value)
//
//                            case .byViews:
//                                Text("조회순")
//                                    .tag(value)
//
//                            case .byComments:
//                                Text("답변순")
//                                    .tag(value)
//                            }
//                        }
//                    }.onChange(of: sortType, perform: { value in
//                        viewModel.fetchTravelOnList(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: value.rawValue, withOpinions: withOpinions, withNonOpinions: withNonOpinions)
//                    })
//                }
            })
        }
    }
    
    func checkOpinions() {
        if (withOpinions == true) && (withNonOpinions == true) {
            withOpinions = false
            withNonOpinions = false
        }
    }
}

struct TravelOnListScreen: View {
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    
    var body: some View {
        NavigationView {
            // TODO: search bar
            
            // TODO: 추천순 · 조회순 · 답변 많은 순 - 지역 선택 - 답변 토글
            
            // TODO: 여행On Text
            
            ZStack {
                // 여행On Component
                ScrollView {
                    VStack {
                        ForEach(viewModel.travelOns) { travelOn in
                            NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOn.id)){
                                TravelOnComponent(travelOn: travelOn)
                                    .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                            }
                        }
                    }
                }
                
                // 글쓰기 버튼
                NavigationLink(destination: TravelOnWriteScreen()) {
                    Text("+")
                }
                .buttonStyle(WriteButtonStyle())
                .padding()
            }
            .navigationBarTitle("", displayMode: .automatic)
            .navigationBarHidden(true)
        }
    }
}

struct TravelOnListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnListScreen()
    }
}
