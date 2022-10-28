//
//  ProfileSettingScreen.swift
//  HeyLocal
//  사용자 앱 설정 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileSettingScreen: View {
    @Environment(\.displayTabBar) var displayTabBar
    var body: some View {
        VStack(alignment: .leading) {
            alarmSetting
                .padding()
            accountSetting
                .padding()
            etcSetting
                .padding()
            
            Spacer()
            
        }
        .navigationTitle("프로필 설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton { displayTabBar(true) })
    }
    
    // MARK: - 알림 설정
    var alarmSetting: some View {
        VStack(alignment: .leading) {
            Text("알림 설정")
                .font(.system(size: 14))
                .foregroundColor(Color("gray"))
            
            Spacer()
                .frame(height: 10)
            
            /// 알림 설정 페이지
            NavigationLink(destination: EmptyView()) {
                HStack {
                    Text("푸쉬 알림 설정")
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.black)
            }
        }
    }
    
    // MARK: - 계정 설정
    var accountSetting: some View {
        VStack(alignment: .leading) {
            Text("계정 설정")
                .font(.system(size: 14))
                .foregroundColor(Color("gray"))
            
            
            /// 연결된 계정
            HStack {
                Text("연결된 계정")
                    .font(.system(size: 16))
                
                Spacer()
                
                // TODO: 연결된 계정 뜨기 해야 함
                Image("logo-kakao")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 54)
            }
            
            
            /// 로그아웃
            // TODO: Alert 후
            Button(action: {
                AuthManager.shared.removeAll()
            }) {
                Text("로그아웃")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
            }
            
            Spacer()
                .frame(height: 10)
            
            /// 회원탈퇴
            Button(action: {
                
            }) {
                Text("회원탈퇴")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
            }
        }
    }
    
    var etcSetting: some View {
        VStack(alignment: .leading) {
            Text("기타")
                .font(.system(size: 14))
                .foregroundColor(Color("gray"))
            
            Spacer()
                .frame(height: 10)
            
            /// 이용약관
            NavigationLink(destination: EmptyView()) {
                HStack {
                    Text("이용약관")
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.black)
            }
        }
    }
}

struct ProfileSettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingScreen()
    }
}
