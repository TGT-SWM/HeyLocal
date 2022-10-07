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
        @Published var travelOns = [TravelOn]()
        @Published var travelOn: TravelOnDetail
        @Published var memberSet: [Bool] = [false, false, false, false, false, false]
        
        var cancellable: AnyCancellable?
        init() {
            self.travelOn = TravelOnDetail(id: 0,
                                           title: "제목 Test",
                                           views: 0,
                                           region: Region(id: 259, state: "부산광역시"),
                                           author: User(nickname: "김현지", imageUrl: "", knowHow: 0, ranking: 0),
                                           travelStartDate: "2022-08-15",
                                           travelEndDate: "2022-08-17",
                                           createdDateTime: "2022-09-01T12:38:43.01024",
                                           modifiedDate: "2022-09-01T12:38:43.01024",
                                           transportationType: "OWN_CAR",
                                           travelMemberSet: [HopeType(id: 1, type: "CHILD"), HopeType(id: 1, type: "PET")],
                                           accommodationMaxCost: 100000,
                                           hopeAccommodationSet: [HopeType(id: 1, type: "ALL")],
                                           hopeFoodSet: [HopeType(id: 1, type: "CHINESE")],
                                           hopeDrinkSet: [HopeType(id: 1, type: "SOJU"), HopeType(id: 2, type: "BEER")],
                                           travelTypeGroup: TravelType(id: 1,
                                                                       placeTasteType: "FAMOUS",
                                                                       activityTasteType: "HARD",
                                                                       snsTasteType: "NO"),
                                           description: "string")
            
            
            cancellable = travelOnService.getTravelOnLists(lastItemId: nil, pageSize: 15, regionId: nil, sortBy: "DATE", withOpinions: nil)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { travelOns in
                    self.travelOns = travelOns
                })
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
                    
                    for i in 0 ..< self.travelOn.travelMemberSet!.count {
                        switch self.travelOn.travelMemberSet![i].type {
                        case "ALONE":
                            self.memberSet[0] = true
                        case "CHILD":
                            self.memberSet[1] = true
                        case "PARENT":
                            self.memberSet[2] = true
                        case "COUPLE":
                            self.memberSet[3] = true
                        case "FRIEND":
                            self.memberSet[4] = true
                        case "PET":
                            self.memberSet[5] = true
                        default:
                            self.memberSet[0] = true
                        }
                    }
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
