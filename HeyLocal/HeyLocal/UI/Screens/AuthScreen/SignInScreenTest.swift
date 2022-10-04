//
//  SignInScreenTest.swift
//  HeyLocal
//	로그인 연동 테스트
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import Combine

// 로그인 API 연동 테스트만을 위한 코드입니다.
struct SignInScreenTest: View {
	@ObservedObject var viewModel = ViewModel()
	
    var body: some View {
		VStack {
			// 입력 폼
			TextField("아이디 입력", text: $viewModel.accountId)
				.autocapitalization(.none)
			SecureField("비밀번호 입력", text: $viewModel.password)
			
			// 확인 버튼
			Button("로그인") {
				print(viewModel.accountId)
				print(viewModel.password)
				viewModel.signIn()
			}.alert(isPresented: $viewModel.showingAlert) {
				Alert(
					title: Text("로그인 성공"),
					message: Text("\(viewModel.nickname)님, 환영합니다."),
					dismissButton: .default(Text("Ok"))
				)
			}
		}.padding()
    }
}

extension SignInScreenTest {
	class ViewModel: ObservableObject {
		let authService = AuthService()
		var cancellable: AnyCancellable?
		
		@Published var accountId = ""
		@Published var password = ""
		@Published var showingAlert = false
		@Published var nickname = ""
		
		func signIn() {
			print(self.cancellable)
			self.cancellable = authService.signIn(accountId: accountId, password: password)
				.sink(receiveCompletion: { _ in
					self.showingAlert = true
				}, receiveValue: { signInInfo in
					self.nickname = signInInfo.nickname
					print(self.nickname)
				})
		}
	}
}

struct SignInScreenTest_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreenTest()
    }
}
