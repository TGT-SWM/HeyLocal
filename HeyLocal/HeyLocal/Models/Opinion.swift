//
//  Opinion.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct Opinion: Decodable, Identifiable {
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
enum LikertScale: String, CaseIterable {
    case VERY_BAD = "매우 나쁨"
    case BAD = "나쁨"
    case NOT_BAD = "보통"
    case GOOD = "좋음"
    case VERY_GOOD = "매우 좋음"
}
