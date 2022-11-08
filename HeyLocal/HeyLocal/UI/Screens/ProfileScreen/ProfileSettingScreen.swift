//
//  ProfileSettingScreen.swift
//  HeyLocal
//  사용자 앱 설정 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import MessageUI

struct ProfileSettingScreen: View {
    @Environment(\.displayTabBar) var displayTabBar
	@StateObject var viewModel = ProfileScreen.ViewModel()
	
    var body: some View {
		ZStack {
			VStack(alignment: .leading) {
//				alarmSetting // TODO: 알림 기능
//					.padding()
				accountSetting
					.padding()
				etcSetting
					.padding()
				
				Spacer()
				
			}
			
			if viewModel.showAlert {
				CustomAlert(
					showingAlert: $viewModel.showAlert,
					title: viewModel.alertTitle,
					cancelMessage: "취소",
					confirmMessage: "확인",
					cancelWidth: 134,
					confirmWidth: 109,
					rightButtonAction: viewModel.handleAlertConfirm
				)
			}
		}
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton { displayTabBar(true) })
        .onAppear {
            displayTabBar(false)
        }
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
			
			Spacer()
				.frame(height: 10)
            
            
            /// 연결된 계정
//            HStack { // TODO: 소셜 로그인 기능
//                Text("연결된 계정")
//                    .font(.system(size: 16))
//
//                Spacer()
//
//                // TODO: 연결된 계정 뜨기 해야 함
//                Image("logo-kakao")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 54)
//            }
            
            
            /// 로그아웃
            // TODO: Alert 후
            Button(action: {
				viewModel.logout()
            }) {
                Text("로그아웃")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
            }
            
            Spacer()
                .frame(height: 10)
            
            /// 회원탈퇴
            Button(action: {
				viewModel.deleteAccount()
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
			
			// 이용약관
			NavigationLink(destination: TOSScreen()) {
				HStack {
					Text("서비스 이용약관")
						.font(.system(size: 16))
					
					Spacer()
					
					Image(systemName: "chevron.right")
				}
				.foregroundColor(Color.black)
			}
			
			Spacer()
				.frame(height: 10)
            
            // 개인정보 처리방침
            NavigationLink(destination: PrivacyPolicyScreen()) {
                HStack {
                    Text("개인정보 처리방침")
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.black)
            }
			
			Spacer()
				.frame(height: 10)
			
			// 개발자에게 문의하기
			Button {
				if MFMailComposeViewController.canSendMail() {
					viewModel.showMailView = true
				}
				
			} label: {
				HStack {
					Text("개발자에게 문의하기")
						.font(.system(size: 16))
					
					Spacer()
					
					Text("tgt.heylocal@gmail.com")
						.font(.system(size: 12))
				}
			}
			.buttonStyle(PlainButtonStyle())
			.sheet(isPresented: $viewModel.showMailView) {
				MailView(
					to: "tgt.heylocal@gmail.com",
					subject: "",
					content: ""
				)
			}
        }
    }
}

struct ProfileSettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingScreen()
    }
}
