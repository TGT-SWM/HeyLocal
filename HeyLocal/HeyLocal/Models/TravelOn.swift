//
//  TravelOn.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct TravelOn: Codable, Identifiable {
    var id: Int
    
    var title: String
    var region: String
    
    var uploadDate: Date
    var writer: User
    
    var numOfViews: Int
    var numOfComments: Int
}
