//
//  Region.swift
//  HeyLocal
//  지역 관련 모델 
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct Region: Codable, Identifiable, Hashable {
    var id: Int = 0
    var city: String? = nil
    var state: String = ""
}
