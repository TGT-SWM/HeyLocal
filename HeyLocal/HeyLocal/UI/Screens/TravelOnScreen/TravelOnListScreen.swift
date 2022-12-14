//
//  TravelOnListScreen.swift
//  HeyLocal
//  여행On 리스트 화면 (전체 여행On 조회)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnListScreen: View {
    @StateObject var viewModel = ViewModel()
    @StateObject var regionViewModel = RegionPickerScreen.ViewModel()
    @Environment(\.displayTabBar) var displayTabBar
    
    // 필터링요소
    @State var sortBy: SortType = .byDate
    @Binding var regionId: Int?
    @State var withOpinions = false
    @State var keyword: String = ""
    @State var selectedRegion: String = "지역별"
    enum SortType: String, CaseIterable, Identifiable {
        case byDate = "DATE"
        case byViews = "VIEWS"
        case byComments = "OPINIONS"
        
        var id: String { self.rawValue }
    }
    
	init(regionId: Binding<Int?>) {
		self._regionId = regionId
	}
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBar(placeholder: "", searchText: $keyword)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .onChange(of: keyword, perform: { value in
                        viewModel.removeTravelOns()
                        viewModel.fetchTravelOns(keyword: value, regionId: regionId, sortBy: sortBy.rawValue, withOpinions: withOpinions)
                    })
                    
                sortType
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))

                ZStack(alignment: .bottomTrailing) {
                    if viewModel.travelOns.count > 0 {
                        content
                    }
                    else {
                        emptyView
                    }
                    // 글쓰기 버튼
                    NavigationLink(destination: TravelOnWriteScreen()) { FAB() }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 20))
                    
//                    NavigationLink(destination: TravelOnWriteScreen()) {
//                        Text("+")
//                    }
//                    .buttonStyle(WriteButtonStyle())
//                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 10))
                }
            }
            .navigationBarTitle("", displayMode: .automatic)
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                viewModel.removeTravelOns()
                viewModel.fetchTravelOns(keyword: keyword, regionId: regionId, sortBy: sortBy.rawValue, withOpinions: withOpinions)
				
				if let regionId = self.regionId {
					regionViewModel.getRegion(regionId: regionId)
				}
				
                displayTabBar(true)
            }
			.onChange(of: regionId) { value in
				print("regionId changed to \(value)")
			}
        }
    }
    
    var sortType: some View {
        VStack(alignment: .leading) {
            HStack {
                // SortBy
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
                    viewModel.removeTravelOns()
                    viewModel.fetchTravelOns(keyword: keyword, regionId: regionId, sortBy: value.rawValue, withOpinions: withOpinions)
                })
                
                Spacer()
                    .frame(width: 13)
                
                // 지역 선택
                NavigationLink(destination: RegionPickerScreen(regionID: $regionId, forSort: true)) {
                    HStack {
                        if regionId == nil {
                            Text("지역별")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                        }
                        
                        else {
                            Text("\(regionViewModel.regionName)")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                        }
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                            .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    }
                }
                .onChange(of: regionId, perform: { value in
                    viewModel.removeTravelOns()
                    viewModel.fetchTravelOns(keyword: keyword, regionId: value, sortBy: sortBy.rawValue, withOpinions: withOpinions)
                    
                    if value != nil {
                        regionViewModel.getRegion(regionId: value!)
                    }
                })
                
                
                Spacer()
                    .frame(width: 13)
                
                // 답변 Toggle
                Toggle("답변있는 게시물", isOn: $withOpinions)
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 117/255, green: 118/255, blue: 121/255))
                    .toggleStyle(CustomToggleStyle())
                    .onChange(of: withOpinions, perform: { value in
                        viewModel.removeTravelOns()
                        viewModel.fetchTravelOns(keyword: keyword, regionId: regionId, sortBy: sortBy.rawValue, withOpinions: value)
                    })
            }
        }
    }
    
    var content: some View {
        ScrollView {
            VStack {
                LazyVStack {
                    ForEach(viewModel.travelOns) { travelOn in
                        NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOn.id)){
                            TravelOnComponent(travelOn: travelOn)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        }
                    }
                    
                    if !viewModel.isEnd {
                        ProgressView()
                            .onAppear{
                                viewModel.fetchTravelOns(keyword: keyword, regionId: regionId, sortBy: sortBy.rawValue, withOpinions: withOpinions)
                            }
                    }
                }
            }
        }
    }
    
    var emptyView: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                
                Group{
                    Text("이런, 작성된 여행On이 없어요")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                    
                    Text("여행On을 작성해볼까요?")
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .font(.system(size: 14))
        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
        .frame(maxHeight: .infinity)
    }
}

struct TravelOnListScreen_Previews: PreviewProvider {
    static var previews: some View {
		TravelOnListScreen(regionId: .constant(267))
    }
}
