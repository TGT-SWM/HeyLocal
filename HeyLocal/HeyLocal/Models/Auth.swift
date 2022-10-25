//
//  Auth.swift
//  HeyLocal
//	인증 관련 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

/// 사용자 아이디 중복 체크 시 응답 데이터
struct CheckDuplicateIdResponse: Decodable {
	var alreadyExist: Bool
}

/// 로그인 성공 시 응답 데이터
struct SignInResponse: Decodable {
	var id: Int
	var accountId: String
	var nickname: String
	var userRole: String
	var accessToken: String
	var refreshToken: String
}
