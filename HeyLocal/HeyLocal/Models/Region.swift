//
//  Region.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

let regionStates: [String] = ["부산광역시", "인천광역시", "광주광역시", "대전광역시", "울산광역시", "세종특별자치시", "제주특별자치도", "서울특별시"]

struct Region: Decodable {
    var id: Int = 0
    var city: String? = nil
    var state: String = ""
}
