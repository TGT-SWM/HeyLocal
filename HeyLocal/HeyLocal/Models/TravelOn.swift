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
    var userProfile: User
    var views: Int
    var opinionQuantity: Int
    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case title = "title"
//        case region = "region"
//        case uploadDate = "modifiedDate"
//        case writer = "userProfile"
//        case numOfViews = "views"
//        case numOfComments = "opinionQuantity"
//    }
}



/*
 {
    "createdDateTime": "2022-09-06T07:14:26.074Z",
    "description": "string",
    "id": 0,
    "modifiedDate": "2022-09-06T07:14:26.074Z",
    "opinionQuantity": 0,
    "region": {
      "city": "string",
      "id": 0,
      "state": "string"
    },
    "title": "string",
    "userProfile": {
      "imageUrl": "string",
      "knowHow": 0,
      "nickname": "string",
      "ranking": 0
    },
    "views": 0
  }
 */
