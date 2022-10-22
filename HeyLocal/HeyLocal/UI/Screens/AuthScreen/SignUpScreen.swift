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
	@Environment(\.displayTabBar) var displayTabBar
	@ObservedObject var vm = ViewModel()
	
	var body: some View {
		NavigationView {
			VStack {
				form
				social
				Spacer()
			}
			.navigationTitle("회원가입")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: BackButton())
			.onAppear { displayTabBar(false) }
			.onDisappear { displayTabBar(false) }
		}
	}
	
	/// 입력 폼에 대한 뷰입니다.
	var form: some View {
		VStack(spacing: 16) {
			// 닉네임
			field(name: "닉네임", value: $vm.nickname, placeholder: "2-10자 이내로 입력해주세요", secured: false)
				.padding(.horizontal, 20)
			
			// 아이디
			idField
			
			// 비밀번호
			field(name: "비밀번호", value: $vm.password, placeholder: "10-20자 이내로 입력해주세요", secured: true)
				.padding(.horizontal, 20)
			
			// 비밀번호 확인
			field(name: "비밀번호 확인", value: $vm.rePassword, placeholder: "10-20자 이내로 입력해주세요", secured: true)
				.padding(.horizontal, 20)
			
			// 회원가입 버튼
			submitButton
		}
		.padding(.top, 42)
	}
	
	/// 아이디 입력 필드에 대한 뷰입니다.
	var idField: some View {
		HStack(alignment: .bottom) {
			field(name: "아이디", value: $vm.id, placeholder: "영문, 숫자  15자 이내", secured: false)
			Button {
			} label: {
				Text("중복확인")
					.font(.system(size: 14))
					.fontWeight(.medium)
					.foregroundColor(.white)
			}
			.frame(width: 80, height: 44)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(Color("orange"))
			)
		}
		.padding(.horizontal, 20)
	}
	
	/// 회원가입 버튼 뷰입니다.
	var submitButton: some View {
		Button {
		} label: {
			ZStack {
				RoundedRectangle(cornerRadius: 22)
					.fill(Color("orange"))
					.frame(height: 44)
				Text("회원가입")
					.foregroundColor(.white)
					.font(.system(size: 14))
					.fontWeight(.medium)
			}
		}
		.padding(.horizontal, 20)
		.padding(.top, 16)
	}
	
	/// 소셜 로그인에 대한 뷰입니다.
	var social: some View {
		EmptyView()
	}
	
	/// 입력 필드에 대한 뷰를 반환합니다.
	func field(name: String, value: Binding<String>, placeholder: String, secured: Bool) -> some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(name)
				.font(.system(size: 14))
				.fontWeight(.medium)
			
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), lineWidth: 1)
					.background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
				
				if secured {
					SecureField(placeholder, text: value)
						.font(.system(size: 12))
						.padding(.horizontal, 12)
				} else {
					TextField(placeholder, text: value)
						.font(.system(size: 12))
						.padding(.horizontal, 12)
				}
			}
			.frame(height: 44)
		}
	}
}


// MARK: - Previews

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
