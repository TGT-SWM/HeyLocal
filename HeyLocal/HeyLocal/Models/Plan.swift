//
//  Plan.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct MyPlans: Decodable {
	var past: [Plan]
	var ongoing: [Plan]
	var upcoming: [Plan]
}

struct Plan: Decodable {
	var id: Int
	var regionId: Int
	var regionState: String
	var regionCity: String
	var startDate: String
	var endDate: String
}
