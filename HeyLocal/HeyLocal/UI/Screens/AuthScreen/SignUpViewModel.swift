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
		// 의존성
		let authService = AuthService()
		
		// 상태 (입력 폼)
		@Published var nickname = ""
		@Published var id = ""
		@Published var password = ""
		@Published var rePassword = ""
		
		// 상태 (UI)
		@Published var isDuplicateId: Bool?
		@Published var showAlert = false
		@Published var alertMsg = ""
		
		// 정규표현식
		let nicknameValidator = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9가-힣]{2,20}$")
		let idValidator = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9]{5,20}$")
		let passwordValidator = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$")
	}
}


// MARK: - 입력 값에 대한 검증

extension SignUpScreen.ViewModel {
	/// 아이디의 중복 체크를 수행합니다.
	func confirmDuplicateId() {
		authService.checkDuplicateId(accountId: id) { isDuplicateId in
			self.isDuplicateId = isDuplicateId
		}
	}
	
	/// 모든 필드에 값이 입력되어 있는지 확인합니다.
	func checkFormFilled() -> Bool {
		if nickname.isEmpty {
			alert(message: "닉네임을 입력해주세요.")
			return false
			
		} else if id.isEmpty {
			alert(message: "아이디를 입력해주세요.")
			return false
			
		} else if password.isEmpty {
			alert(message: "비밀번호를 입력해주세요.")
			return false
			
		} else if rePassword.isEmpty {
			alert(message: "확인 비밀번호를 입력해주세요.")
			return false
		}
		
		return true
	}
	
	/// 입력 형식을 체크합니다.
	func checkFormat() -> Bool {
		// 닉네임 입력 형식 체크
		if !nicknameValidator.evaluate(with: nickname) {
			alert(message: "닉네임 형식이 잘못되었습니다.")
			return false
		}
		
		// 아이디 입력 형식 체크
		if !idValidator.evaluate(with: id) {
			alert(message: "아이디 형식이 잘못되었습니다.")
			return false
		}
		
		// 패스워드 입력 형식 체크
		if !passwordValidator.evaluate(with: password) {
			alert(message: "패스워드 형식이 잘못되었습니다.")
			return false
		}
		
		return true
	}
	
	/// 비밀번호를 잘 입력했는지 확인합니다.
	func confirmPassword() -> Bool {
		return password == rePassword
	}
}


// MARK: - 회원가입 기능
extension SignUpScreen.ViewModel {
	/// 회원가입을 요청합니다.
	func signUp(onSuccess: @escaping () -> Void) {
		// 모든 필드가 입력되었나
		if !checkFormFilled() { return }
		
		// 입력 형식에 문제가 없나
		if !checkFormat() { return }
		
		// 확인 비밀번호를 잘 입력했나
		if !confirmPassword() {
			self.alert(message: "확인 비밀번호의 값이 다릅니다.")
			return
		}
		
		// 회원가입 요청
		authService.signUp(
			accountId: id,
			nickname: nickname,
			password: password
		) { errMsg in
			if let msg = errMsg { // 회원가입 실패
				self.alert(message: msg)
			} else { // 회원가입 성공
				onSuccess()
			}
		}
	}
}


// MARK: - 알림 모달 출력

extension SignUpScreen.ViewModel {
	/// 해당 메시지의 알림 모달을 띄웁니다.
	func alert(message: String) {
		self.showAlert = true
		self.alertMsg = message
	}
}
