//
//  Place.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// 장소
struct Place: Decodable, Hashable {
	var id: Int
	var name: String
	var address: String
	var roadAddress: String
	var lat: Double
	var lng: Double
}
