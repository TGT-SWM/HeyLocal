//
//  SignInScreen.swift
//  HeyLocal
//  로그인 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - SignInScreen (로그인 화면)

struct SignInScreen: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationView {
			ZStack {
				VStack(spacing: 0) {
					logo
					form
					social
					signUp
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
        }
    }
	
	/// 서비스 로고 이미지에 대한 뷰입니다.
	var logo: some View {
		Image("logo")
			.resizable()
			.scaledToFit()
			.frame(height: 32)
			.padding(.vertical, 80)
	}
	
	/// 회원가입 화면으로 이동하는 버튼에 대한 뷰입니다.
	var signUp: some View {
		HStack {
			Text("반가워요, 현지야 첫 방문이신가요?")
				.font(.system(size: 12))
				.foregroundColor(Color("gray"))
			NavigationLink(destination: SignUpScreen()) {
				Text("회원가입")
					.font(.system(size: 14))
					.fontWeight(.medium)
					.foregroundColor(.black)
					.underline()
			}
		}
	}
}


// MARK: - 입력 폼

extension SignInScreen {
	/// 로그인 정보 입력 폼에 대한 뷰입니다.
	var form: some View {
		VStack {
			idField
			passwordField
			submitButton
		}
	}
	
	/// 로그인 아이디 입력 필드에 대한 뷰입니다.
	var idField: some View {
		AuthTextField(value: $vm.id, placeholder: "아이디")
			.keyboardType(.asciiCapable)
			.autocapitalization(.none)
			.padding(.horizontal, 20)
	}
	
	/// 로그인 패스워드 입력 필드에 대한 뷰입니다.
	var passwordField: some View {
		AuthTextField(value: $vm.password, placeholder: "비밀번호", secured: true)
			.padding(.horizontal, 20)
	}
	
	/// 로그인 버튼 뷰입니다.
	var submitButton: some View {
		Button(action: vm.signIn) {
			ZStack {
				RoundedRectangle(cornerRadius: 22)
					.fill(Color("orange"))
					.frame(height: 44)
				Text("로그인")
					.foregroundColor(.white)
					.font(.system(size: 14))
					.fontWeight(.medium)
			}
		}
		.padding(.horizontal, 20)
		.padding(.vertical, 20)
	}
}


// MARK: - 소셜 로그인

extension SignInScreen {
	var social: some View {
		EmptyView()
	}
}


// MARK: - Previews

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
