//
//  Place.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// 장소
struct Place: Decodable {
	var id: Int
	var name: String
	var address: String
	var roadAddress: String
}
