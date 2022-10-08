//
//  TravelOnViewModel.swift
//  HeyLocal
//  여행On 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension TravelOnListScreen {
    class ViewModel: ObservableObject {
        private var travelOnService = TravelOnService()
        @Published var travelOns: [TravelOn]
        @Published var travelOn: TravelOn
        @Published var travelOnArray: TravelOnArray
        
        
        
        @Published var memberSet: [Bool] = [false, false, false, false, false, false]
        
        var cancellable: AnyCancellable?
        init() {
            self.travelOn = TravelOn()
            self.travelOns = [TravelOn()]
            self.travelOnArray = TravelOnArray()
        }
        
        // Travel On 전체 목록
        func fetchTravelOnList(lastItemId: Int?, pageSize: Int, regionId: Int?, sortBy: String, withOpinions: Bool) {
            // withOpinions -> nil 확인
            var withOpinion: Bool? = nil
            if withOpinions == true {
                withOpinion = true
            }
            
            cancellable = travelOnService.getTravelOnLists(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy, withOpinions: withOpinion)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { travelOns in
                    self.travelOns = travelOns
                })
        }
        
        // Travel On 상세조회
        func fetchTravelOn(travelOnId: Int) {
            cancellable = travelOnService.getTravelOn(travelOnId: travelOnId)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { travelOn in
                    self.travelOn = travelOn
                    
                    /* TravelOn to TravelOnArray */
                    self.travelOnArray.title = self.travelOn.title
                    self.travelOnArray.regionId = self.travelOn.region.id
                    self.travelOnArray.regionName = regionNameFormatter(region: self.travelOn.region)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = TimeZone(identifier: "KST")
                    self.travelOnArray.startDate = dateFormatter.date(from: self.travelOn.travelStartDate!)!
                    self.travelOnArray.endDate = dateFormatter.date(from: self.travelOn.travelEndDate!)!

                    // 동행자
                    for i in 0..<self.travelOn.travelMemberSet!.count {
                        switch self.travelOn.travelMemberSet![i].type {
                        case "ALONE":
                            self.travelOnArray.memberSet[0] = true
                        case "CHILD":
                            self.travelOnArray.memberSet[1] = true
                        case "PARENT":
                            self.travelOnArray.memberSet[2] = true
                        case "COUPLE":
                            self.travelOnArray.memberSet[3] = true
                        case "FRIEND":
                            self.travelOnArray.memberSet[4] = true
                        case "PET":
                            self.travelOnArray.memberSet[5] = true
                        default:
                            self.travelOnArray.memberSet[0] = false
                        }
                    }

                    // 숙소
                    for i in 0..<self.travelOn.hopeAccommodationSet!.count {
                        switch self.travelOn.hopeAccommodationSet![i].type {
                        case "HOTEL":
                            self.travelOnArray.accomSet[0] = true
                        case "PENSION":
                            self.travelOnArray.accomSet[1] = true
                        case "CAMPING":
                            self.travelOnArray.accomSet[2] = true
                        case "GUEST_HOUSE":
                            self.travelOnArray.accomSet[3] = true
                        case "RESORT":
                            self.travelOnArray.accomSet[4] = true
                        case "ALL":
                            self.travelOnArray.accomSet[5] = true
                        default:
                            self.travelOnArray.accomSet[5] = false
                        }
                    }
                    
                    // 숙소 가격대
                    switch self.travelOn.accommodationMaxCost {
                    case 100000:
                        self.travelOnArray.accomPrice = .ten
                    case 200000:
                        self.travelOnArray.accomPrice = .twenty
                    case 300000:
                        self.travelOnArray.accomPrice = .thirty
                    case 400000:
                        self.travelOnArray.accomPrice = .forty
                    case 0:
                        self.travelOnArray.accomPrice = .etc
                    default:
                        self.travelOnArray.accomPrice = .etc
                    }

                    // 교통수단
                    switch self.travelOn.transportationType {
                    case "OWN_CAR":
                        self.travelOnArray.transSet[0] = true

                    case "RENT_CAR":
                        self.travelOnArray.transSet[1] = true

                    case "PUBLIC":
                        self.travelOnArray.transSet[2] = true

                    default:
                        self.travelOnArray.transSet[0] = false
                    }

                    // 선호 음식
                    for i in 0..<self.travelOn.hopeFoodSet!.count {
                        switch self.travelOn.hopeFoodSet![i].type {
                        case "KOREAN":
                            self.travelOnArray.foodSet[0] = true
                        case "WESTERN":
                            self.travelOnArray.foodSet[1] = true
                        case "CHINESE":
                            self.travelOnArray.foodSet[2] = true
                        case "JAPANESE":
                            self.travelOnArray.foodSet[3] = true
                        case "GLOBAL":
                            self.travelOnArray.foodSet[4] = true
                        default:
                            self.travelOnArray.foodSet[4] = false
                        }
                    }

                    // 선호 주류
                    for i in 0..<self.travelOn.hopeDrinkSet!.count {
                        switch self.travelOn.hopeDrinkSet![i].type {
                        case "SOJU":
                            self.travelOnArray.drinkSet[0] = true
                        case "BEER":
                            self.travelOnArray.drinkSet[1] = true
                        case "WINE":
                            self.travelOnArray.drinkSet[2] = true
                        case "MAKGEOLLI":
                            self.travelOnArray.drinkSet[3] = true
                        case "LIQUOR":
                            self.travelOnArray.drinkSet[4] = true
                        case "NO_ALCOHOL":
                            self.travelOnArray.drinkSet[5] = true
                        default:
                            self.travelOnArray.drinkSet[5] = false
                        }
                    }

                    // 여행 취향
                    if self.travelOn.travelTypeGroup!.placeTasteType == "FAMOUS" {
                        self.travelOnArray.place = true
                    } else {
                        self.travelOnArray.fresh = true
                    }

                    if self.travelOn.travelTypeGroup!.activityTasteType == "HARD" {
                        self.travelOnArray.activity = true
                    } else {
                        self.travelOnArray.lazy = true
                    }

                    if self.travelOn.travelTypeGroup!.snsTasteType == "YES" {
                        self.travelOnArray.sns = true
                    } else {
                        self.travelOnArray.noSNS = true
                    }
                    
                    self.travelOnArray.description = self.travelOn.description
                })
        }
        
        // Travel On 삭제
        func deleteTravelOn(travelOnId: Int) {
            travelOnService.deleteTravelOn(travelOnId: travelOnId)
        }
        
        // Travel On 등록
        func postTravelOn(travelOnData: TravelOnPost) -> Int {
            return travelOnService.postTravelOn(travelOnData: travelOnData)
        }
        
        // Travel On 수정
        func updateTravelOn(travelOnId: Int, travelOnData: TravelOnPost) {
            return travelOnService.updateTravelOn(travelOnID: travelOnId, travelOnData: travelOnData)
        }
    }
}
