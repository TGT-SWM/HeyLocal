//
//  OpinionViewModel.swift
//  HeyLocal
//  답변 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

extension OpinionComponent {
    class ViewModel: ObservableObject {
        let LikertScale: [String] = ["VERY_BAD", "BAD", "NOT_BAD", "GOOD", "VERY_GOOD"]
        let restaurantMoodStr: [String] = ["LIVELY", "FORMAL", "ROMANTIC", "HIP", "COMFORTABLE"]
        let cafeMoodStr: [String] = ["MODERN", "LARGE", "CUTE", "HIP"]
        let coffeeStr: [String] = ["BITTER", "SOUR", "GENERAL"]
        
        private var opinionService = OpinionService()
        @Published var opinions: [Opinion]
        @Published var opinion: Opinion
        
        // 공통 질문
        @Published var cleanArray: [Bool] = [false, false, false, false, false]
        @Published var costArray: [Bool] = [false, false, false, false, false]
        @Published var parkingArray: [Bool] = [false, false, false, false, false]
        @Published var waitingArray: [Bool] = [false, false, false, false, false]
        @Published var cleanInt: Int = 0
        @Published var costInt: Int = 0
        @Published var parkingInt: Int = 0
        @Published var waitingInt: Int = 0
        
        // 음식점
        @Published var restaurantMood: [Bool] = [false, false, false, false, false]
        
        // 카페
        @Published var coffee: [Bool] = [false, false, false]
        @Published var cafeMood: [Bool] = [false, false, false, false]
        
        // 숙박
        @Published var noise: [Bool] = [false, false, false, false, false]
        @Published var deafening: [Bool] = [false, false, false, false, false]
        @Published var noiseInt: Int = 0
        @Published var deafeningInt: Int = 0
        
        
        var cancellable: AnyCancellable?
        init() {
            self.opinions = [Opinion()]
            self.opinion = Opinion()
            
        }
        
        // 답변 목록조회
        func fetchOpinions(travelOnId: Int, opinionId: Int?) {
            cancellable = opinionService.getOpinions(travelOnId: travelOnId)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { opinions in
                    self.opinions = opinions
                    
                    // 답변 상세조회
                    if opinionId != nil {
                        for i in 0 ..< self.opinions.count {
                            if self.opinions[i].id == opinionId {
                                self.opinion = self.opinions[i]
                                
                                // 공통질문
                                self.cleanInt = self.getLikertInt(str: self.opinion.facilityCleanliness)
                                for i in 0 ..< self.cleanInt {
                                    self.cleanArray[i] = true
                                }
                                self.costInt = self.getLikertInt(str: self.opinion.costPerformance)
                                for i in 0 ..< self.costInt {
                                    self.costArray[i] = true
                                }
                                self.parkingInt = self.getLikertInt(str: self.opinion.canParking)
                                for i in 0 ..< self.parkingInt {
                                    self.parkingArray[i] = true
                                }
                                self.waitingInt = self.getLikertInt(str: self.opinion.waiting)
                                for i in 0 ..< self.waitingInt {
                                    self.waitingArray[i] = true
                                }
                                
                                // 음식점
                                if self.opinion.place.category == "FD6" {
                                    for i in 0..<self.restaurantMoodStr.count {
                                        if self.opinion.restaurantMoodType == self.restaurantMoodStr[i] {
                                            self.restaurantMood[i] = true
                                            break
                                        }
                                    }
                                }
                                
                                // 카페
                                else if self.opinion.place.category == "CE7" {
                                    // 커피 타입
                                    for i in 0..<self.coffeeStr.count {
                                        if self.opinion.coffeeType == self.coffeeStr[i] {
                                            self.coffee[i] = true
                                            break
                                        }
                                    }
                                    
                                    // 카페 무드
                                    for i in 0..<self.cafeMoodStr.count {
                                        if self.opinion.cafeMoodType == self.cafeMoodStr[i] {
                                            self.cafeMood[i] = true
                                            break
                                        }
                                    }
                                }
                                
                                
                                // 숙박
                                else if self.opinion.place.category == "AD5" {
                                    self.deafeningInt = self.getLikertInt(str: self.opinion.deafening!)
                                    for i in 0 ..< self.deafeningInt {
                                        self.deafening[i] = true
                                    }
                                    self.noiseInt = self.getLikertInt(str: self.opinion.streetNoise!)
                                    for i in 0 ..< self.noiseInt {
                                        self.noise[i] = true
                                    }
                                }
                                
                                break
                            }
                        }
                    }
                })
        }
        
        // 답변 삭제
        func deleteOpinion(travelOnId: Int, opinionId: Int){
            return opinionService.deleteOpinion(travelOnId: travelOnId, opinionId: opinionId)
        }
        
        // 답변 등록
        func postOpinion(travelOnId: Int, opinionData: Opinion) -> Int {
            return opinionService.postOpinion(travelOnId: travelOnId, opinionData: opinionData)
        }
        
        // 답변 수정
        func updateOpinion(travelOnId: Int, opinionId: Int, opinionData: Opinion) {
            return opinionService.updateOpinion(travelOnId: travelOnId, opinionId: opinionId, opinionData: opinionData)
        }
        
        // Likert to Int
        func getLikertInt(str: String) -> Int {
            for i in 0..<5 {
                if str == LikertScale[i] {
                    return i + 1
                }
            }
            return 0
        }
    }
}
