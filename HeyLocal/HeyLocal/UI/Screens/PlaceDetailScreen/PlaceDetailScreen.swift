//
//  PlaceDetailScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlaceDetailScreen (장소 상세 화면)

struct PlaceDetailScreen: View {
	@Environment(\.displayTabBar) var displayTabBar
	var place: Place
	@ObservedObject var vm: ViewModel
	
	init(place: Place) {
		self.place = place
		self.vm = ViewModel(place: place)
	}
	
    var body: some View {
		ScrollView {
			header // 상단 영역
			if vm.displayMenu { menuList } // 메뉴 (음식점, 카페)
			Divider() // 구분선
				.frame(minHeight: 8)
				.frame(maxWidth: .infinity)
				.overlay(Color("lightGray"))
			opinionList // 답변 목록
		}
		.navigationTitle("장소 상세정보")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				BackButton { displayTabBar(true) }
			}
		}
		.onAppear {
			vm.fetchDetailInfo()
			displayTabBar(false)
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
		.padding(20)
	}
	
	/// 장소의 이름과 카테고리에 대한 뷰입니다.
	var titleView: some View {
		HStack(alignment: .bottom) {
			Text(place.name)
				.font(.system(size: 22))
				.fontWeight(.medium)
			
			Text(place.categoryName)
				.font(.system(size: 12))
				.foregroundColor(Color("orange"))
			
			Spacer()
		}
	}
	
	/// 장소의 주소에 대한 뷰입니다.
	var addressView: some View {
		HStack(alignment: .top) {
			Image("location")
				.font(.system(size: 10))
			
			VStack(alignment: .leading) {
				Text(place.roadAddress)
				Text(place.address)
			}
			.font(.system(size: 12))
			.foregroundColor(Color("gray"))
			
			Spacer()
		}
	}
	
	/// 장소의 영업 시간에 대한 뷰입니다.
	var openingTimeView: some View {
		HStack {
			Image("clock-outline")
				.font(.system(size: 10))
			
			if vm.openingTimes.isEmpty {
				Text("-")
					.font(.system(size: 12))
					.foregroundColor(Color("gray"))
			} else {
				VStack {
					ForEach(vm.openingTimes, id: \.self) {
						Text($0)
							.font(.system(size: 12))
							.foregroundColor(Color("gray"))
					}
				}
			}
			
			Spacer()
		}
	}
}


// MARK: - menuList (메뉴 뷰)

extension PlaceDetailScreen {
	/// 메뉴 리스트에 대한 뷰입니다.
	var menuList: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text("메뉴")
				.font(.system(size: 16))
				.fontWeight(.medium)
			
			VStack(spacing: 0) {
				ForEach(vm.menus, id: \.self) {
					menuListItem(menu: $0)
				}
			}
			.padding(.vertical, 16)
		}
		.padding(.horizontal, 20)
	}
	
	/// 메뉴 리스트의 각 항목에 대한 뷰입니다.
	func menuListItem(menu: PlaceDetail.MenuInfo) -> some View {
		HStack {
			Text(menu.name)
				.font(.system(size: 12))
			
			Spacer()
			
			Text(menu.price)
				.font(.system(size: 12))
		}
		.frame(height: 24)
	}
}


// MARK: - opinionList (답변 리스트 뷰)

extension PlaceDetailScreen {
	/// 답변 리스트에 대한 뷰입니다.
	var opinionList: some View {
		VStack(alignment: .leading) {
			Text("이 장소 관련 답변")
				.font(.system(size: 16))
				.fontWeight(.medium)
				.padding(.bottom, 12)
			
			LazyVStack(spacing: 12) {
				ForEach(vm.opinions) {
					opinionListItem(opinion: $0)
				}
				
				// 더 이상 로드할 컨텐츠가 없는 경우 표시하지 않습니다.
				if !vm.isEnd {
					ProgressView()
						.onAppear(perform: vm.fetchOpinions)
				}
			}
		}
		.padding(.horizontal, 20)
		.padding(.vertical, 12)
	}
	
	/// 답변 리스트의 각 항목에 대한 뷰입니다.
	func opinionListItem(opinion: Opinion) -> some View {
		ZStack(alignment: .bottomTrailing) {
			NavigationLink(destination: OpinionDetailScreen(
				travelOnId: opinion.travelOnId!,
				opinionId: opinion.id
			)) {
				OpinionComponent(opinion: opinion)
			}
			
			addPlaceButton(opinion: opinion)
		}
	}
	
	/// '플랜에 추가' 버튼 뷰입니다.
	func addPlaceButton(opinion: Opinion) -> some View {
		NavigationLink(destination: PlanSelectScreen(opinionId: opinion.id)) {
			ZStack(alignment: .center) {
				RoundedRectangle(cornerRadius: 100)
					.fill(Color("orange"))
					.frame(width: 80, height: 32)
				
				Text("플랜에 추가")
					.font(.system(size: 12))
					.foregroundColor(.white)
			}
		}
	}
}


// MARK: - Previews

struct PlaceDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
		PlaceDetailScreen(place: Place(
			id: 100,
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
