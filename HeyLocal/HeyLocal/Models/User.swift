//
//  User.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int?
    var accountId: String?
    var nickname: String = ""
    var imageUrl: String? = ""
    var knowHow: Int? = 0
    var ranking: Int?
}
