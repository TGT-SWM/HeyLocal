//
//  Plan.swift
//  HeyLocal
//	플랜 관련 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

/// 마이 플랜 목록
struct MyPlans: Decodable {
	var past: [Plan] = []
	var ongoing: [Plan] = []
	var upcoming: [Plan] = []
}

/// 플랜
struct Plan: Decodable {
	var id: Int
	var title: String
	var regionId: Int
	var regionState: String
	var regionCity: String?
	var regionImageURL: String {
		"\(Config.apiURL)/static/regions/img/\(regionId).jpeg"
	}
	var startDate: String
	var endDate: String
	var transportationType: String
	
	var regionName: String {
		if let city = regionCity {
			return "\(regionState) \(city)"
		}
		return regionState
	}
}

/// 플랜 내 하루 스케줄
struct DaySchedule: Codable {
	var date: String
	var places: [Place] = []
}

/// 플랜의 스케줄들
struct DaySchedules: Codable {
	var schedules: [DaySchedule]
}
