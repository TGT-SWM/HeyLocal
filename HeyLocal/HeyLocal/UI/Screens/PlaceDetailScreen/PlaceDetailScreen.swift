//
//  PlaceDetailScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlaceDetailScreen (장소 상세 화면)

struct PlaceDetailScreen: View {
	var place: Place
	var vm: ViewModel
	
	init(place: Place) {
		self.place = place
		self.vm = ViewModel(place: place)
	}
	
    var body: some View {
		VStack {
			header
			menuList
			opinionList
		}
		.navigationTitle("장소 상세정보")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				BackButton()
			}
		}
    }
}


// MARK: - header (상단 영역 뷰)

extension PlaceDetailScreen {
	/// 상단 영역의 뷰입니다.
	var header: some View {
		VStack {
			titleView
			addressView
			openingTimeView
		}
	}
	
	/// 장소의 이름과 카테고리에 대한 뷰입니다.
	var titleView: some View {
		HStack {
			Text(place.name)
			Text(place.categoryName)
		}
	}
	
	/// 장소의 주소에 대한 뷰입니다.
	var addressView: some View {
		HStack(alignment: .top) {
			Image("location")
			VStack {
				Text(place.roadAddress)
				Text(place.address)
			}
		}
	}
	
	/// 장소의 영업 시간에 대한 뷰입니다.
	var openingTimeView: some View {
		HStack {
			Image("clock-outline")
			Text("매일 10:30 - 21:30")
		}
	}
}


// MARK: - menuList (메뉴 뷰)

extension PlaceDetailScreen {
	var menuList: some View {
		VStack {
			Text("메뉴")
		}
	}
}


// MARK: - opinionList (답변 리스트 뷰)

extension PlaceDetailScreen {
	var opinionList: some View {
		VStack {
			Text("이 장소 관련 답변")
			
			LazyVStack {
				ForEach(vm.opinions) {
					OpinionComponent(opinion: $0)
				}
				
				// 더 이상 로드할 컨텐츠가 없는 경우 표시하지 않습니다.
				if !vm.isEnd {
					ProgressView()
						.onAppear {
							vm.fetchOpinions()
						}
				}
			}
		}
	}
}


// MARK: - Previews

struct PlaceDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
		PlaceDetailScreen(place: Place(
			id: 1,
			name: "할머니 밀면집",
			category: "FD6",
			address: "부산광역시 중구 남포동2가 17-1",
			roadAddress: "부산광역시 중구 광복로 56-14",
			lat: 0,
			lng: 0,
			link: ""
		))
    }
}
