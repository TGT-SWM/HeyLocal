//
//  Place.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// 장소
struct Place: Decodable, Equatable {
	var id: Int
	var name: String
	var address: String
	var roadAddress: String
	var lat: Double
	var lng: Double
	
	static func == (lhs: Place, rhs: Place) -> Bool {
		lhs.id == rhs.id
	}
}
