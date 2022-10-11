//
//  Opinion.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct Opinion: Codable, Identifiable {
    // MARK: - 필수
    var id: Int = 0
    var author: Author = Author()
    var countAccept: Int = 0
    var description: String = ""
    var place: TmpPlace = TmpPlace()
    
    // MARK: - 공통 · 기타
    var generalImgDownloadImgUrl: [String] = []
    var facilityCleanliness: String = ""
    var canParking: Bool = false
    var waiting: Bool = false
    var costPerformance: String = ""
    
    // MARK: - 음식점 FD6
    var restaurantMoodType: String? = ""
    var recommendFoodDescription: String? = ""
    var foodImgDownloadImgUrl: [String]? = []
     
    // MARK: - 카페 CE7
    var coffeeType: String? = ""
    var recommendDrinkAndDessertDescription: String? = ""
    var drinkAndDessertImgDownloadImgUrl: [String]? = []
    var cafeMoodType: String? = ""
    
    // MARK: - 문화시설 CT1 · 관광명소 AT4
    var recommendToDo: String? = ""
    var recommendSnack: String? = ""
    var photoSpotDescription: String? = ""
    var photoSpotImgDownloadImgUrl: [String]? = []
    
    // MARK: - 숙박 AD5
    var streetNoise: String? = ""
    var deafening: String? = ""
    var hasBreakFast: Bool? = false
}
struct TmpPlace: Codable {
    var id: Int = 0
    var name: String = ""
    var address: String = ""
    var category: String = ""
    var region: Region = Region()
    var roadAddress: String? = ""
    var thumbnailUrl: String? = ""
    var kakaoLink: String? = ""
    var lat: Double? = 0
    var lng: Double? = 0
}

//
//{
//  "cafeMoodType": "CUTE",
//  "canParking": false,
//  "coffeeType": "BITTER",
//  "costPerformance": "BAD",
//  "deafening": "BAD",
//  "description": "string",
//  "facilityCleanliness": "BAD",
//  "hasBreakFast": false,
//  "photoSpotDescription": "string",
//  "place": {
//    "address": "string",
//    "category": "AC5",
//    "id": 0,
//    "kakaoLink": "string",
//    "lat": 0,
//    "lng": 0,
//    "name": "string",
//    "roadAddress": "string",
//    "thumbnailUrl": "string"
//  },
//  "quantity": {
//    "drinkAndDessertImgQuantity": 0,
//    "foodImgQuantity": 0,
//    "generalImgQuantity": 0,
//    "photoSpotImgQuantity": 0
//  },
//  "recommendDrinkAndDessertDescription": "string",
//  "recommendFoodDescription": "string",
//  "recommendSnack": "string",
//  "recommendToDo": "string",
//  "restaurantMoodType": "COMFORTABLE",
//  "streetNoise": "BAD",
//  "waiting": false
//}
