//
//  Plan.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct PlanListEntity: Decodable {
	var past: [PlanListItemEntity]
	var ongoing: [PlanListItemEntity]
	var upcoming: [PlanListItemEntity]
}

struct PlanListItemEntity: Decodable {
	var id: Int
	var regionId: Int
	var regionState: String
	var regionCity: String
	var startDate: String
	var endDate: String
}
