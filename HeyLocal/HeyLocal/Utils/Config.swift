//
//  Config.swift
//  HeyLocal
//	Configuration 값 관리
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

/// 프로젝트 Configuration 값들을 이곳에 모아 선언합니다.
struct Config {
	static let apiURL = Bundle.main.object(forInfoDictionaryKey: "API_URL")!
	static let accessToken = Bundle.main.object(forInfoDictionaryKey: "ACCESS_TOKEN")!
	static let refreshToken = Bundle.main.object(forInfoDictionaryKey: "REFRESH_TOKEN")!
	static let kakaoRestURL = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_URL")!
	static let kakaoRestKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_KEY")!
	static let odsayApiKey = Bundle.main.object(forInfoDictionaryKey: "ODSAY_API_KEY")!
	static let odsayApiURL = Bundle.main.object(forInfoDictionaryKey: "ODSAY_API_URL")!
}
