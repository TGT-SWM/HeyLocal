//
//  Opinion.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
//{"id":12,"description":"string","author":{"userId":2,"introduce":"테스트 계정, 자기소개!!","nickname":"testNickname9876","profileImgDownloadUrl":"https://heylocal.s3.ap-northeast-2.amazonaws.com/profiles/2/profile.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20221009T033848Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=AKIA2LHRCTPCMLEEM7UT%2F20221009%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=8cf38f74db9482cfe8138275c6ffc5cdc92fc8ea8ad5b5ecc3265b751779ec01","knowHow":0,"ranking":0,"activityRegion":{"id":259,"state":"부산광역시","city":null},"acceptedOpinionCount":0},"generalImgDownloadImgUrl":[],"foodImgDownloadImgUrl":[],"drinkAndDessertImgDownloadImgUrl":[],"photoSpotImgDownloadImgUrl":[],"countAccept":0,"facilityCleanliness":"BAD","costPerformance":"BAD","canParking":false,"waiting":false,"restaurantMoodType":"COMFORTABLE","recommendFoodDescription":"string","coffeeType":"BITTER","recommendDrinkAndDessertDescription":"string","cafeMoodType":"CUTE","recommendToDo":"string","recommendSnack":"string","photoSpotDescription":"string","streetNoise":"BAD","deafening":"BAD","hasBreakFast":false,"place":{"id":23,"category":"AC5","name":"string","roadAddress":"string","address":"대구광역시 어쩌구","lat":10.0,"lng":10.0,"region":{"id":260,"state":"대구광역시","city":null},"thumbnailUrl":"string","kakaoLink":"string"}}
//


// 24
struct Opinion: Decodable, Identifiable {
    var id: Int? = 0
    var author: Author? = Author()
    var countAccept: Int? = 0
    var description: String? = ""
    
    var cafeMoodType: String? = ""
    var coffeeType: String? = ""
    var costPerformance: String? = ""
    var deafening: String? = ""
    
    var drinkAndDessertImgDownloadImgUrl: [String]? = []
    var foodImgDownloadImgUrl: [String]? = []
    var generalImgDownloadImgUrl: [String]? = []
    var photoSpotImgDownloadImgUrl: [String]? = []
    
    
    var place: TmpPlace? = TmpPlace()
    var photoSpotDescription: String? = ""
    var recommendDrinkAndDessertDescription: String? = ""
    var recommendFoodDescription: String? = ""
    var recommendSnack: String? = ""
    var recommendToDo: String? = ""
    var restaurantMoodType: String? = ""
    var streetNoise: String? = ""
    
    
    
    var canParking: Bool? = false
    var hasBreakFast: Bool? = false
    var facilityCleanliness: String? = ""
    var waiting: Bool? = false
}
struct TmpPlace: Decodable {
    var id: Int? = 0
    var name: String? = ""
    var address: String? = ""
    var category: String? = ""
    var region: Region? = Region()
    var roadAddress: String? = ""
    var thumbnailUrl: String? = ""
    var kakaoLink: String? = ""
    var lat: Double? = 0
    var lng: Double? = 0
}


//[

////    "cafeMoodType": "CUTE",
////    "canParking": true,
////    "coffeeType": "BITTER",
////    "costPerformance": "BAD",
////    "countAccept": 0,
////    "deafening": "BAD",
////    "description": "string",
////    "drinkAndDessertImgDownloadImgUrl": [
////      "string"
////    ],
////    "facilityCleanliness": "BAD",
////    "foodImgDownloadImgUrl": [
////      "string"
////    ],
////    "generalImgDownloadImgUrl": [
////      "string"
////    ],
////    "hasBreakFast": true,
////    "id": 0,
////    "photoSpotDescription": "string",
////    "photoSpotImgDownloadImgUrl": [
////      "string"
////    ],
////    "recommendDrinkAndDessertDescription": "string",
////    "recommendFoodDescription": "string",
////    "recommendSnack": "string",
////    "recommendToDo": "string",
////    "restaurantMoodType": "COMFORTABLE",
////    "streetNoise": "BAD",
////    "waiting": true
//  }
//]
