//
//  Main.swift
//  HeyLocal
//	메인 뷰
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - Main

struct Main: View {
	var body: some View {
		TabBar()
	}
}


// MARK: - TabBar (탭 바)

struct TabBar: View {
	let tabBarHeight: CGFloat = 55
	
	/// 현재 보고 있는 탭을 나타냅니다.
	@State private var selection = Tab.home
	
	/// 탭 바를 보여주는지에 대한 상태입니다.
	/// displayTabBar() 메서드를 통해 제어할 수 있습니다.
	@State var _displayTabBar = true
	
	/// 특정 지역을 검색하며 여행 On으로 이동할 때 지역 ID를 담기 위해 사용합니다.
	@State var searchedRegionId: Int?
	
	init() {
		UITabBar.appearance().isHidden = true // 기본 탭 바 숨기기
	}
	
	var body: some View {
		ZStack(alignment: .bottom) {
			baseTabBar
				.environment(\.displayTabBar, displayTabBar)
				.environment(\.navigateToTravelOnWithRegion, navigateToTravelOnWithRegion)
			
			if (_displayTabBar) {
				styledTabBar
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
//		case message = "메시지"
		case myInfo = "내 정보"
		
		/// 해당 탭의 이름을 문자열로 반환합니다.
		var name: String {
			self.rawValue
		}
		
		/// 해당 탭의 아이콘을 이미지로 반환합니다.
		var icon: [Image] {
			switch (self) {
			case .home:
                return [Image("home"), Image("home_pressed")]
			case .travelOn:
				return [Image("travelon"), Image("travelon_pressed")]
			case .myPlan:
				return [Image("myplan"), Image("myplan_pressed")]
//			case .message:
//				return Image(systemName: "message.fill")
			case .myInfo:
				return [Image("my"), Image("my_pressed")]
			}
		}
	}
}


// MARK: - baseTabBar (기본 TabView)

extension TabBar {
	var baseTabBar: some View {
		TabView(selection: $selection) {
			HomeScreen()
				.tag(Tab.home)
			TravelOnListScreen(regionId: $searchedRegionId)
				.tag(Tab.travelOn)
			MyPlanScreen()
				.tag(Tab.myPlan)
//            HomeScreen()
//				.tag(Tab.message)
            ProfileScreen(userId: AuthManager.shared.authorized!.id, showingTab: true)
				.tag(Tab.myInfo)
		}
		.padding(.bottom, _displayTabBar ? tabBarHeight : 0)
	}
}


// MARK: - styledTabBar (커스텀 탭 바)

extension TabBar {
	var styledTabBar: some View {
		VStack(spacing: 0) {
			LinearGradient( // 그림자 효과
				colors: [.black.opacity(0), .black.opacity(0.07)],
				startPoint: .top,
				endPoint: .bottom
			)
			.frame(height: 6)
			
			HStack(spacing: 0) {
				tabItem(.home)
				tabItem(.travelOn)
				tabItem(.myPlan)
//				tabItem(.message)
				tabItem(.myInfo)
			}
			.frame(height: tabBarHeight)
			.background(Color.white.ignoresSafeArea())
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
					
                if selection == tab {
                    tab.icon[1]
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .padding(0)
                }
                else {
                    tab.icon[0]
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .padding(0)
                }
				
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


// MARK: - displayTabBar (탭 바 On/Off를 위한 메서드)

extension TabBar {
	/// 탭 바를 출력할 것인지, 숨길 것인지 설정합니다.
	func displayTabBar(_ _displayTabBar: Bool) {
		// iOS 16 이상에서 여행 On 상세 화면 -> 수정 화면 이동 시 뒤로 돌아오는 문제 유발
//		self._displayTabBar = _displayTabBar
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


// MARK: - 특정 지역 검색 옵션을 갖고 여행 On 화면으로 이동하기

extension TabBar {
	/// 여행 On 탭으로 이동하여 해당 지역의 검색 결과를 출력합니다.
	func navigateToTravelOnWithRegion(regionId: Int) {
		searchedRegionId = regionId
		selection = .travelOn
	}
}

struct NavigateToTravelOnWithRegion: EnvironmentKey {
	static var defaultValue: (Int) -> Void = { _ in }
}

extension EnvironmentValues {
	var navigateToTravelOnWithRegion: (Int) -> Void {
		get { self[NavigateToTravelOnWithRegion.self] }
		set { self[NavigateToTravelOnWithRegion.self] = newValue }
	}
}


// MARK: - Previews

struct Main_Previews: PreviewProvider {
	static var previews: some View {
		Main()
	}
}
