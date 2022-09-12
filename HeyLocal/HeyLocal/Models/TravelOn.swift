//
//  TravelOn.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct TravelOn: Decodable, Identifiable {
    var id: Int
    var title: String
    var region: Region
    var modifiedDate: String
    var user: User
    var views: Int
    var opinionQuantity: Int
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case region = "region"
        case modifiedDate = "modifiedDate"
        case user = "author"
        case views = "views"
        case opinionQuantity = "opinionQuantity"
    }
}

struct TravelOnDetail: Decodable, Identifiable {
    var id: Int?
    var title: String?
    var views: Int?
    var region: Region?
    var author: User?
    
    var travelStartDate: String?
    var travelEndDate: String?
    var createdDateTime: String?
    var modifiedDate: String?
    
    var transportationType: String?
    
    var travelMemberSet: [MemberType]?
    
    var accommodationMaxCost: Int?
    var hopeAccommodationSet: [HopeType]?
    
    var foodMaxCost: Int?
    var hopeFoodSet: [HopeType]?
    
    var drinkMaxCost: Int?
    var hopeDrinkSet: [HopeType]?
    
    var travelTypeGroup: TravelType
    var description: String?
}

struct HopeType: Decodable, Identifiable {
    var id: Int?
    var type: String?
}

struct TravelType: Decodable {
    var id: Int?
    var placeTasteType: String?
    var activityTasteType: String?
    var snsTasteType: String?
}

struct MemberType: Decodable, Identifiable {
    var id: Int?
    var memberType: String?
}
