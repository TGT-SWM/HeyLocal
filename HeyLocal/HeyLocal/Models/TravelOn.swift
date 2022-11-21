//
//  TravelOn.swift
//  HeyLocal
//  여행On 관련 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// MARK: - 여행On Encodable Struct
struct TravelOnPost: Encodable {
    var accommodationMaxCost: Int = 0
    var accommodationTypeSet: [String] = []
    var description: String = ""
    var drinkTypeSet: [String] = []
    var foodTypeSet: [String] = []
    var memberTypeSet: [String] = []
    var regionId: Int = 0
    var title: String = ""
    var transportationType: String = ""
    var travelStartDate: String = ""
    var travelEndDate: String = ""
    var travelTypeGroup: TravelTypePost = TravelTypePost()
}
struct TravelTypePost: Encodable {
    var placeTasteType: String = "FAMOUS"
    var activityTasteType: String = "HARD"
    var snsTasteType: String = "YES"
}
struct TravelOnArray {
    var title: String = ""
    
    var regionId: Int?
    var regionName: String = "여행지 입력"
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    var accomPrice: Price?
    var memberSet: [Bool] = [false, false, false, false, false, false]
    var accomSet: [Bool] = [false, false, false, false, false, false]
    var transSet: [Bool] = [false, false, false]
    var foodSet: [Bool] = [false, false, false, false, false]
    var drinkSet: [Bool] = [false, false, false, false, false, false]
    var place: Bool = false
    var fresh: Bool = false
    var activity: Bool = false
    var lazy: Bool = false
    var sns: Bool = false
    var noSNS: Bool = false
    
    var description: String = ""
}
enum Price: Int, CaseIterable, Identifiable {
    case ten = 100000
    case twenty = 200000
    case thirty = 300000
    case forty = 400000
    case etc = 0
    
    var id: Int { self.rawValue }
}

// MARK: - 여행On Decodable Struct
struct TravelOn: Decodable, Identifiable {
    var id: Int = 0
    var author: Author = Author()
    var createdDateTime: String = "2022-10-07T04:37:44.377Z"
    var modifiedDate: String = "2022-10-07T04:37:44.377Z"
    var title: String = ""
    var description: String = ""
    var region: Region = Region()
    var views: Int = 0
    
    var opinionQuantity: Int? = 0
    var accommodationMaxCost: Int? = 0
    var hopeAccommodationSet: [HopeType]? = [HopeType()]
    var hopeDrinkSet: [HopeType]? = [HopeType()]
    var hopeFoodSet: [HopeType]? = [HopeType()]
    var transportationType: String? = ""
    var travelStartDate: String? = "2022-10-07"
    var travelEndDate: String? = "2022-10-07"
    var travelMemberSet: [HopeType]? = [HopeType()]
    var travelTypeGroup: TravelTypeGroup? = TravelTypeGroup()
}

struct HopeType: Decodable, Identifiable {
    var id: Int = 0
    var type: String = ""
}

struct TravelTypeGroup: Decodable, Identifiable {
    var id: Int = 0
    var placeTasteType: String = "FAMOUS"
    var activityTasteType: String = "HARD"
    var snsTasteType: String = "YES"
}

struct CheckAddressWithTravelOnResponse: Decodable {
	var sameRegionAddress: Bool
}
