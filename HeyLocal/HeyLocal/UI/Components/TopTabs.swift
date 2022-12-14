//
//  TopTabs.swift
//  HeyLocal
//  상단 탭바
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TopTabs: View {
    var fixed = true
    var tabs: [String]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id:\.self) { row in
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(tabs[row])
                                            .font(Font.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color.black)
                                            .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 15))
                                    }
                                    .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 52)
                                    
                                    Rectangle().fill(selectedTab == row ? Color("orange") : Color("lightGray"))
                                        .frame(height: 3)
                                }.fixedSize()
                            })
                            .accentColor(Color.white)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .frame(height: 55)
        .onAppear(perform: {
			// 앱 전체의 스크롤 뷰에 영향
			// 내 정보 -> 마이 플랜 이동 시 마이 플랜 화면에서 bounce 안되는 문제
            UIScrollView.appearance().bounces = fixed ? false : true
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
    }
}
