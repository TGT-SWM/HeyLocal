//
//  SignUpViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// MARK: - SignUpScreen.ViewModel (뷰 모델)

extension SignUpScreen {
	class ViewModel: ObservableObject {
		@Published var nickname = ""
		@Published var id = ""
		@Published var password = ""
		@Published var rePassword = ""
	}
}


// MARK: - 아이디 중복확인 기능
extension SignUpScreen.ViewModel {
	/// 아이디의 중복 체크를 수행합니다.
	func confirmDuplicateId() {
		
	}
}


// MARK: - 비밀번호 확인 기능
extension SignUpScreen.ViewModel {
	/// 비밀번호를 잘 입력했는지 확인합니다.
	func confirmPassword() -> Bool {
		return password == rePassword
	}
}


// MARK: - 회원가입 기능
extension SignUpScreen.ViewModel {
	/// 회원가입을 요청합니다.
	func signUp() {
		
	}
}
