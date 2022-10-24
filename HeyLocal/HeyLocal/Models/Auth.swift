//
//  Auth.swift
//  HeyLocal
//	인증 관련 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct CheckDuplicateIdResponse: Decodable {
	var alreadyExist: Bool
}

/// 사용자의 로그인 정보
struct SignInInfo: Decodable {
	var id: Int
	var accountId: String
	var nickname: String
	var userRole: String
	var accessToken: String
	var refreshToken: String
}
