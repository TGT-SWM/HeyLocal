//
//  Main.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

/// `TabView`를 보여주기 위한 뷰입니다.
struct Main: View {
	@State private var tabSelection = Tab.home
    
    // 탭바 배경색 설정
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
	var body: some View {
        TabView(selection: $tabSelection) {
            // 홈 탭
            HomeScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
                .tag(Tab.home)
            
            // 여행 On 탭
            TravelOnListScreen()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("여행 On")
                }
                .tag(Tab.home)
            
            // 마이플랜 탭
            MyPlanScreen()
                .tabItem {
                    Image(systemName: "suitcase.cart.fill")
                    Text("마이플랜")
                }
                .tag(Tab.home)
            
            // 메시지 탭
            // TODO: 메시지 화면 뷰로 대체
            HomeScreen()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("메시지")
                }
                .tag(Tab.home)
            
            // 내 정보 탭
            MyProfileScreen()
                .tabItem {
                    Image(systemName: "person")
                    Text("내 정보")
                }
                .tag(Tab.home)
        }
	}
	
	/// 탭 유형에 대한 열거형입니다.
	/// `Main` 내부에서만 사용됩니다.
	private enum Tab {
		case home
		case travelOn
		case myPlan
		case message
		case myinfo
	}
}

struct Main_Previews: PreviewProvider {
	static var previews: some View {
		Main()
	}
}
