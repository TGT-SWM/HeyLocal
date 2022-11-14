//
//  Region.swift
//  HeyLocal
//  지역 관련 모델 
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct Region: Codable, Identifiable, Hashable {
    var id: Int = 0
    var city: String? = nil
    var state: String = ""
	var thumbnailUrl: String {
		"\(Config.apiURL)/static/regions/img/\(id).jpeg"
	}
}
