//
//  SignInViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// MARK: - SignInScreen.ViewModel (뷰 모델)

extension SignInScreen {
	class ViewModel: ObservableObject {
		// 의존성
		let authService = AuthService()
		
		// 상태 (입력 폼)
		@Published var id = ""
		@Published var password = ""
		
		// 상태 (알림 모달)
		@Published var showAlert = false
		@Published var alertMsg = ""
	}
}


// MARK: - 로그인 기능

extension SignInScreen.ViewModel {
	/// 입력한 아이디와 패스워드로 로그인을 요청합니다.
	func signIn() {
		authService.signIn(accountId: id, password: password) { errMsg in
			if let msg = errMsg { // 로그인 실패
				self.alert(message: msg)
			} else { // 로그인 성공
				print("로그인 성공") // LOG
			}
		}
	}
}


// MARK: - 알림 모달 출력

extension SignInScreen.ViewModel {
	/// 해당 메시지의 알림 모달을 띄웁니다.
	func alert(message: String) {
		self.showAlert = true
		self.alertMsg = message
	}
}
