//
//  User.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct User: Codable {
    var userId: String
    var nickname: String
    var imageURL: String
    var knowHow: Int
    var ranking: Int
}
