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
    var place: Place = Place(id: 0,
                             name: "",
                             category: "",
                             address: "",
                             roadAddress: "",
                             lat: 0,
                             lng: 0,
                             link: "",
                             region: Region(id: 0, state: ""),
                             thumbnailUrl: "")
    var modifiedDate: String = "2022-10-07T04:37:44.377Z"
    var createdDate: String = "2022-10-07T04:37:44.377Z"
    
    // MARK: - 공통 · 기타
    var generalImgDownloadImgUrl: [String] = []
    var facilityCleanliness: String = ""
    var canParking: String = ""
    var waiting: String = ""
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
