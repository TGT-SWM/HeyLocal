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
        
        
        
        
        @Published var memberSet: [Bool] = [false, false, false, false, false, false]
        
        var cancellable: AnyCancellable?
        init() {
            self.travelOn = TravelOn()
            self.travelOns = [TravelOn()]
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
                    print("HERERe")
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
