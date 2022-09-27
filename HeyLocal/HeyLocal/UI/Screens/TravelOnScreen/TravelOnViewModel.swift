//
//  TravelOnViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension TravelOnListScreen {
    class ViewModel: ObservableObject {
        private var travelOnService = TravelOnService()
        @Published var travelOns = [TravelOn]()
        @Published var travelOn: TravelOnDetail
        
        var cancellable: AnyCancellable?
        init() {
            self.travelOn = TravelOnDetail(id: 0,
                                           title: "title",
                                           views: 0,
                                           region: Region(id: 78, city: "성남시", state: "경기도"),
                                           author: User(nickname: "김현지", imageUrl: "", knowHow: 0, ranking: 0),
                                           travelStartDate: "2022-08-15",
                                           travelEndDate: "2022-08-17",
                                           createdDateTime: "2022-09-01T12:38:43.01024",
                                           modifiedDate: "2022-09-01T12:38:43.01024",
                                           transportationType: "OWN_CAR",
                                           travelMemberSet: [HopeType(id: 1, type: "ALONE")],
                                           accommodationMaxCost: 100000,
                                           hopeAccommodationSet: [HopeType(id: 1, type: "ALL")],
                                           foodMaxCost: 100000,
                                           hopeFoodSet: [HopeType(id: 1, type: "CHINESE")],
                                           drinkMaxCost: 100000,
                                           hopeDrinkSet: [HopeType(id: 1, type: "SOJU"), HopeType(id: 2, type: "BEER")],
                                           travelTypeGroup: TravelType(id: 1,
                                                                       placeTasteType: "FAMOUS",
                                                                       activityTasteType: "HARD",
                                                                       snsTasteType: "NO"),
                                           description: "string")
            
            
            cancellable = travelOnService.getTravelOnLists(lastItemId: nil, pageSize: 5, regionId: nil, sortBy: "DATE", withOpinions: nil)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { travelOns in
                    self.travelOns = travelOns
                })
        }
        
        
        // Travel On 전체 목록
        func fetchTravelOnList(lastItemId: Int?, pageSize: Int, regionId: Int?, sortBy: String, withOpinions: Bool, withNonOpinions: Bool) {
            // withOpinions 값
            var with_opinons: Bool? = nil
            if (withOpinions != withNonOpinions) {
                with_opinons = withOpinions
            }
            
            cancellable = travelOnService.getTravelOnLists(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy, withOpinions: with_opinons)
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
                })
        }
        
        func deleteTravelOn(travelOnId: Int) {
            travelOnService.deleteTravelOn(travelOnId: travelOnId)
        }
        
        func postTravelOn(travelOnData: TravelOnPost) -> Int {
            return travelOnService.postTravelOn(travelOnData: travelOnData)
        }
    }
}
