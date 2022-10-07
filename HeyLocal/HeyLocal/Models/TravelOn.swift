//
//  TravelOn.swift
//  HeyLocal
//  여행On 관련 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// TravelOn -> 보여주기
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
    
    var travelMemberSet: [HopeType]?
    
    var accommodationMaxCost: Int?
    var hopeAccommodationSet: [HopeType]?
    
    var hopeFoodSet: [HopeType]?
    var hopeDrinkSet: [HopeType]?
    
    var travelTypeGroup: TravelType?
    var description: String?
}

struct HopeType: Decodable, Identifiable {
    var id: Int?
    var type: String?
}

struct TravelType: Decodable, Identifiable {
    var id: Int?
    var placeTasteType: String?
    var activityTasteType: String?
    var snsTasteType: String?
}

// Data Model for POST
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


struct TempTravelOnPost: Codable {
    var title: String = ""
//    var 
}
//
//// 제목
//title = viewModel.travelOn.title!
//
//// 지역
//regionId = viewModel.travelOn.region!.id
//regionName = regionNameFormatter(region: viewModel.travelOn.region!)
//// 여행 날짜
//let dateFormatter = DateFormatter()
//dateFormatter.dateFormat = "yyyy-MM-dd"
//dateFormatter.timeZone = TimeZone(identifier: "KST")
//startDate = dateFormatter.date(from: viewModel.travelOn.travelStartDate!)!
//endDate = dateFormatter.date(from: viewModel.travelOn.travelEndDate!)!
//
//// 동행자
//for i in 0..<viewModel.travelOn.travelMemberSet!.count {
//    switch viewModel.travelOn.travelMemberSet![i].type {
//    case "ALONE":
//        memberSet[0] = true
//    case "CHILD":
//        memberSet[1] = true
//    case "PARENT":
//        memberSet[2] = true
//    case "COUPLE":
//        memberSet[3] = true
//    case "FRIEND":
//        memberSet[4] = true
//    case "PET":
//        memberSet[5] = true
//    default:
//        memberSet[0] = true
//    }
//}
//
//// 숙소
//for i in 0..<viewModel.travelOn.hopeAccommodationSet!.count {
//    switch viewModel.travelOn.hopeAccommodationSet![i].type {
//    case "HOTEL":
//        accomSet[0] = true
//    case "PENSION":
//        accomSet[1] = true
//    case "CAMPING":
//        accomSet[2] = true
//    case "GUEST_HOUSE":
//        accomSet[3] = true
//    case "RESORT":
//        accomSet[4] = true
//    case "ALL":
//        accomSet[5] = true
//    default:
//        accomSet[5] = true
//    }
//}
//switch viewModel.travelOn.accommodationMaxCost {
//case 100000:
//    accomPrice = .ten
//case 200000:
//    accomPrice = .twenty
//case 300000:
//    accomPrice = .thirty
//case 400000:
//    accomPrice = .forty
//case 0:
//    accomPrice = .etc
//default:
//    accomPrice = .etc
//}
//
//
//// 교통수단
//switch viewModel.travelOn.transportationType {
//case "OWN_CAR":
//    transSet[0] = true
//
//case "RENT_CAR":
//    transSet[1] = true
//
//case "PUBLIC":
//    transSet[2] = true
//
//default:
//    transSet[0] = true
//}
//
//// 선호 음식
//for i in 0..<viewModel.travelOn.hopeFoodSet!.count {
//    switch viewModel.travelOn.hopeFoodSet![i].type {
//    case "KOREAN":
//        foodSet[0] = true
//    case "WESTERN":
//        foodSet[1] = true
//    case "CHINESE":
//        foodSet[2] = true
//    case "JAPANESE":
//        foodSet[3] = true
//    case "GLOBAL":
//        foodSet[4] = true
//    default:
//        foodSet[4] = true
//    }
//}
//
//// 선호 주류
//for i in 0..<viewModel.travelOn.hopeDrinkSet!.count {
//    switch viewModel.travelOn.hopeDrinkSet![i].type {
//    case "SOJU":
//        drinkSet[0] = true
//    case "BEER":
//        drinkSet[1] = true
//    case "WINE":
//        drinkSet[2] = true
//    case "MAKGEOLLI":
//        drinkSet[3] = true
//    case "LIQUOR":
//        drinkSet[4] = true
//    case "NO_ALCOHOL":
//        drinkSet[5] = true
//    default:
//        drinkSet[5] = true
//    }
//}
//
//// 여행 취향
//if viewModel.travelOn.travelTypeGroup!.placeTasteType == "FAMOUS" {
//    place = true
//} else {
//    fresh = true
//}
//
//if viewModel.travelOn.travelTypeGroup!.activityTasteType == "HARD" {
//    activity = true
//} else {
//    lazy = true
//}
//
//if viewModel.travelOn.travelTypeGroup!.snsTasteType == "YES" {
//    sns = true
//} else {
//    noSNS = true
//}
//description = viewModel.travelOn.description!
