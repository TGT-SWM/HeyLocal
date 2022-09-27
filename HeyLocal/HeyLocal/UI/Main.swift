//
//  Main.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - Main (뷰의 엔트리 포인트)

struct Main: View {
	var body: some View {
		TabBar()
	}
}


// MARK: - TabBar (탭 바)

struct TabBar: View {
	@State private var selection = Tab.home
	
	var body: some View {
		ZStack {
			baseTabView
			styledTabView
		}
	}
}


// MARK: - Tab (탭의 유형)

extension TabBar {
	enum Tab: String {
		case home = "홈"
		case travelOn = "여행 On"
		case myPlan = "마이플랜"
		case message = "메시지"
		case myInfo = "내 정보"
		
		/// 해당 탭의 이름을 문자열로 반환합니다.
		var name: String {
			self.rawValue
		}
		
		/// 해당 탭의 아이콘을 이미지로 반환합니다.
		var icon: Image {
			switch (self) {
			case .home:
				return Image(systemName: "house.fill")
			case .travelOn:
				return Image(systemName: "note.text")
			case .myPlan:
				return Image(systemName: "suitcase.cart.fill")
			case .message:
				return Image(systemName: "message.fill")
			case .myInfo:
				return Image(systemName: "person")
			}
		}
	}
}


// MARK: - baseTabView (선택된 탭의 화면을 출력)

extension TabBar {
	var baseTabView: some View {
		TabView(selection: $selection) {
			HomeScreen()
				.tag(Tab.home)
			
			TravelOnListScreen()
				.tag(Tab.travelOn)
			
			MyPlanScreen()
				.tag(Tab.myPlan)
			
			HomeScreen()
				.tag(Tab.message)
			
			MyProfileScreen()
				.tag(Tab.myInfo)
		}
	}
}


// MARK: - styledTabView (탭 바의 디자인)

extension TabBar {
	var styledTabView: some View {
		HStack {
			tabItem(.home)
			tabItem(.travelOn)
			tabItem(.myPlan)
			tabItem(.message)
			tabItem(.myInfo)
		}
	}
	
	func tabItem(_ tab: Tab) -> some View {
		Button {
			selection = tab
		} label: {
			VStack {
				tab.icon
				Text(tab.name)
			}
		}
	}
}


// MARK: - Previews

struct Main_Previews: PreviewProvider {
	static var previews: some View {
		Main()
	}
}
