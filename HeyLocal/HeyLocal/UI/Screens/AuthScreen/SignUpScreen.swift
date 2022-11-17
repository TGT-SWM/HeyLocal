//
//  SignUpScreen.swift
//  HeyLocal
//  회원가입 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - SignUpScreen (회원가입 화면)

struct SignUpScreen: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.displayTabBar) var displayTabBar
	@ObservedObject var vm = ViewModel()
	
	var body: some View {
		ZStack {
			VStack {
				form
				social
				Spacer()
			}
			
			if vm.showAlert {
				ConfirmModal(
					title: "안내",
					message: vm.alertMsg,
					showModal: $vm.showAlert
				)
			}
		}
		.navigationTitle("회원가입")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton())
		.onAppear { displayTabBar(false) }
		.onDisappear { displayTabBar(false) }
	}
}


// MARK: - 입력 폼
extension SignUpScreen {
	/// 입력 폼에 대한 뷰입니다.
	var form: some View {
		VStack(spacing: 16) {
			// 입력 필드
			nicknameField
			idField
			passwordField
			rePasswordField
			
			// 약관
			tosLink
			privacyPolicyLink
			
			// 회원가입 버튼
			submitButton
		}
		.padding(.top, 42)
	}
	
	/// 닉네임 입력 필드에 대한 뷰입니다.
	var nicknameField: some View {
		AuthTextField(name: "닉네임", value: $vm.nickname, placeholder: "영문, 한글, 숫자 조합 2자 ~ 20자", secured: false)
			.padding(.horizontal, 20)
	}
	
	/// 아이디 입력 필드에 대한 뷰입니다.
	var idField: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .bottom) {
				AuthTextField(name: "아이디", value: $vm.id, placeholder: "영문, 숫자 조합 5자 ~ 20자", secured: false)
					.keyboardType(.asciiCapable)
					.autocapitalization(.none)
				
				Button {
					vm.confirmDuplicateId()
				} label: {
					Text("중복확인")
						.font(.system(size: 14))
						.fontWeight(.medium)
						.foregroundColor(.white)
				}
				.frame(width: 80, height: 44)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(vm.isIdFormatValid ? Color("orange") : Color("lightGray"))
				)
				.disabled(!vm.isIdFormatValid)
			}
			
			if let showMsgForDupId = vm.isDuplicateId {
				Text(showMsgForDupId
					 ? "이미 사용 중인 아이디입니다."
					 : "사용 가능한 아이디입니다."
				)
				.font(.system(size: 12))
			}
		}
		.padding(.horizontal, 20)
	}
	
	/// 패스워드 입력 필드에 대한 뷰입니다.
	var passwordField: some View {
		AuthTextField(name: "비밀번호", value: $vm.password, placeholder: "숫자, 영어, 특수 문자 조합 8자 이상", secured: true)
			.padding(.horizontal, 20)
	}
	
	/// 패스워드 재입력 필드에 대한 뷰입니다.
	var rePasswordField: some View {
		AuthTextField(name: "비밀번호 확인", value: $vm.rePassword, placeholder: "비밀번호를 한번 더 입력해주세요", secured: true)
			.padding(.horizontal, 20)
	}
	
	/// 회원가입 버튼 뷰입니다.
	var submitButton: some View {
		Button {
			vm.signUp {
				dismiss()
			}
		} label: {
			ZStack {
				RoundedRectangle(cornerRadius: 22)
					.fill(Color("orange"))
					.frame(height: 44)
				Text("약관 동의 및 회원가입")
					.foregroundColor(.white)
					.font(.system(size: 14))
					.fontWeight(.medium)
			}
		}
		.padding(.horizontal, 20)
		.padding(.top, 16)
	}
}


// MARK: - 소셜 로그인
extension SignUpScreen {
	/// 소셜 로그인에 대한 뷰입니다.
	var social: some View {
		EmptyView()
	}
}


// MARK: - 알림 모달

extension SignUpScreen {
	var alert: some View {
		ZStack(alignment: .center) {
			Color.black.opacity(0.15)
				.edgesIgnoringSafeArea(.all)
			
			RoundedRectangle(cornerRadius: 10)
				.fill(.white)
				.shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
				.shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
		}
	}
}


// MARK: - 약관 확인

extension SignUpScreen {
	/// 이용약관을 확인하기 위한 버튼입니다.
	var tosLink: some View {
		HStack {
			Spacer()
			NavigationLink(destination: TOSScreen()) {
				HStack {
					Text("서비스 이용약관 확인하기")
						.fontWeight(.medium)
					Image(systemName: "chevron.right")
				}
				.font(.system(size: 12))
			}
			.foregroundColor(Color("orange"))
		}
		.padding(.horizontal, 20)
	}
	
	/// 개인정보 처리방침을 확인하기 위한 버튼입니다.
	var privacyPolicyLink: some View {
		HStack {
			Spacer()
			NavigationLink(destination: PrivacyPolicyScreen()) {
				HStack {
					Text("개인정보 처리방침 확인하기")
						.fontWeight(.medium)
					Image(systemName: "chevron.right")
				}
				.font(.system(size: 12))
			}
			.foregroundColor(Color("orange"))
		}
		.padding(.horizontal, 20)
	}
}


// MARK: - Previews

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
