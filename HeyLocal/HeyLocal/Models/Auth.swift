//
//  Auth.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

/// 사용자의 로그인 정보
struct SignInInfo: Decodable {
	var id: Int
	var accountId: String
	var nickname: String
	var userRole: String
	var accessToken: String
	var refreshToken: String
}
