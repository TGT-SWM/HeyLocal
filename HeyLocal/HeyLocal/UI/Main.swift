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
	@State var _displayTabBar = true
	
	var body: some View {
		ZStack(alignment: .bottom) {
			baseTabView
				.environment(\.displayTabBar, displayTabBar)
			
			if (_displayTabBar) {
				styledTabView
			}
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
		VStack {
			HStack(spacing: 0) {
				tabItem(.home)
				tabItem(.travelOn)
				tabItem(.myPlan)
				tabItem(.message)
				tabItem(.myInfo)
			}
			.frame(height: 55)
			.background(
				Rectangle()
					.fill(.white)
					.shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: -2)
			)
		}
	}
	
	func tabItem(_ tab: Tab) -> some View {
		Button {
			selection = tab
		} label: {
			VStack(alignment: .center, spacing: 0) {
				Divider()
					.frame(minHeight: 3)
					.overlay(selection == tab ? Color("orange") : Color(red: 0.85, green: 0.85, blue: 0.85))

				Spacer(minLength: 0)
					
				tab.icon
					.font(.system(size: 20))
					.padding(0)
				Text(tab.name)
					.font(.system(size: 12))
					.padding(.top, 4)
				
				Spacer(minLength: 0)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.foregroundColor(selection == tab ? .black : Color("gray"))
		}
		.buttonStyle(PlainButtonStyle())
	}
}


// MARK: - displayTabBar

extension TabBar {
	/// 탭 바를 출력할 것인지, 숨길 것인지 설정합니다.
	func displayTabBar(_ _displayTabBar: Bool) {
		self._displayTabBar = _displayTabBar
		UITabBar.appearance().isHidden = !_displayTabBar // 기본 탭 바
	}
}

struct DisplayTabBar: EnvironmentKey {
	static var defaultValue: (Bool) -> Void = { _ in }
}

extension EnvironmentValues {
	/// 탭 바의 출력 여부를 설정하는 메서드입니다.
	var displayTabBar: (Bool) -> Void {
		get { self[DisplayTabBar.self] }
		set { self[DisplayTabBar.self] = newValue }
	}
}


// MARK: - Previews

struct Main_Previews: PreviewProvider {
	static var previews: some View {
		Main()
	}
}
