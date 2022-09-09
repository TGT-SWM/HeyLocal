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
        case user = "userProfile"
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
    var hopeAccomodationSet: [HopeType]?
    
    var foodMaxCost: Int?
    var hopeFoodSet: [HopeType]?
    
    var drinkMaxCost: Int?
    var hopeDrinkSet: [HopeType]?
    
    var travelTypeGroup: TravelType
}

struct HopeType: Decodable {
    var id: Int?
    var type: String?
}

struct TravelType: Decodable {
    var id: Int?
    var placeTasteType: String?
    var activityTasteType: String?
    var snsTasteType: String?
}

/*
 
 {
   "accommodationMaxCost": 0,
   "author": {
     "accountId": "string",
     "id": 0,
     "imageUrl": "string",
     "knowHow": 0,
     "nickname": "string"
   },
   "createdDateTime": "2022-09-09T07:59:25.299Z",
   "drinkMaxCost": 0,
   "foodMaxCost": 0,
   "hopeAccommodationSet": [
     {
       "id": 0,
       "type": "ALL"
     }
   ],
   "hopeDrinkSet": [
     {
       "id": 0,
       "type": "BEER"
     }
   ],
   "hopeFoodSet": [
     {
       "id": 0,
       "type": "CHINESE"
     }
   ],
   "id": 0,
   "modifiedDate": "2022-09-09T07:59:25.299Z",
   "region": {
     "city": "string",
     "id": 0,
     "state": "string"
   },
   "title": "string",
   "transportationType": "OWN_CAR",
   "travelEndDate": "2022-09-09",
   "travelMemberSet": [
     {
       "id": 0,
       "memberType": "ALONE"
     }
   ],
   "travelStartDate": "2022-09-09",
   "travelTypeGroup": {
     "activityTasteType": "HARD",
     "id": 0,
     "placeTasteType": "FAMOUS",
     "snsTasteType": "NO"
   },
   "views": 0
 }
 
 */
