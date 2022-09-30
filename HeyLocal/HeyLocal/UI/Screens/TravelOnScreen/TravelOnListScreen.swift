//
//  TravelOnListScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnListScreen: View {
    @StateObject var viewModel = ViewModel()
    @State var searchText: String = ""
    
    @State var sortBy: SortType = .byDate
    @State var selectedRegion: String = "지역별"
    @State var regionId: Int? = nil
    
    @State var withOpinions = false

    @State var lastItemId: Int? = nil
    @State var pageSize: Int = 5
    
    
    enum SortType: String, CaseIterable, Identifiable {
        case byDate = "DATE"
        case byViews = "VIEWS"
        case byComments = "OPINIONS"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 5) {
                SearchBar(placeholder: "", searchText: $searchText)
                
                HStack {
                    // 정렬 Picker
                    HStack {
                        Menu {
                            Picker(selection: $sortBy) {
                                ForEach(SortType.allCases, id:\.id) { value in
                                    switch value {
                                    case .byDate:
                                        Text("최신순")
                                            .tag(value)
                                            .font(.system(size: 12))

                                    case .byViews:
                                        Text("조회순")
                                            .tag(value)
                                            .font(.system(size: 12))

                                    case .byComments:
                                        Text("답변순")
                                            .tag(value)
                                            .font(.system(size: 12))
                                    }
                                }
                            } label: {}
                        } label: {
                            HStack {
                                switch sortBy {
                                case .byDate:
                                    Text("최신순")
                                        .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                        .font(.system(size: 12))

                                case .byViews:
                                    Text("조회순")
                                        .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                        .font(.system(size: 12))

                                case .byComments:
                                    Text("답변순")
                                        .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                        .font(.system(size: 12))
                                }
                                
                                Spacer()
                                    .frame(width: 3)
                                
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10)
                                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                            }
                        }.id(sortBy)
                    }
                    .onChange(of: sortBy, perform: { value in
                        viewModel.fetchTravelOnList(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: value.rawValue, withOpinions: withOpinions)
                    })
                    
                    Spacer()
                        .frame(width: 13)
                    
                    // 지역 선택
                    Button(action: {}) {
                        HStack {
                            Text("\(selectedRegion)")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10)
                                .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                        }
                    }
                    
                    Spacer()
                        .frame(width: 13)
                    
                    // 답변 Toggle
                    Toggle("답변있는 게시물", isOn: $withOpinions)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 117/255, green: 118/255, blue: 121/255))
                        .toggleStyle(CustomToggleStyle())
                        .onChange(of: withOpinions, perform: { value in
                            viewModel.fetchTravelOnList(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy.rawValue, withOpinions: withOpinions)
                        })
                }
                
                Text("여행On📝")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                
                ZStack(alignment: .bottomTrailing) {
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
                }
                .onAppear {
                    viewModel.fetchTravelOnList(lastItemId: nil, pageSize: 5, regionId: nil, sortBy: "DATE", withOpinions: false)
                }
                .navigationBarTitle("", displayMode: .automatic)
                .navigationBarHidden(true)
            }
        }
    }
}

struct TravelOnListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnListScreen()
    }
}
