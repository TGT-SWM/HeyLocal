//
//  TravelOnService.swift
//  HeyLocal
//  여행On 서비스
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct TravelOnService {
    private var travelOnRepository = TravelOnRepository()
    
    // 전체 여행On 조회
    func getTravelOnLists(lastItemId: Int?, pageSize: Int, regionId: Int?, sortBy: String, withOpinions: Bool?) -> AnyPublisher<[TravelOn], Error> {
        return travelOnRepository.getTravelOnLists(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy, withOpinions: withOpinions)
    }
    
    // 여행On 상세 조회
    func getTravelOn(travelOnId: Int) -> AnyPublisher<TravelOnDetail, Error> {
        return travelOnRepository.getTravelOn(travelOnId: travelOnId)
    }
    
    // 여행On 삭제
    func deleteTravelOn(travelOnId: Int) {
        return travelOnRepository.deleteTravelOn(travelOnId: travelOnId)
    }
    
    // 여행On 등록
    func postTravelOn(travelOnData: TravelOnPost) -> Int {
        return travelOnRepository.postTravelOn(travelOnData: travelOnData)
    }
    
    // 여행On 수정
    func updateTravelOn(travelOnID: Int, travelOnData: TravelOnPost) {
        return travelOnRepository.updateTravelOn(travelOnId: travelOnID, travelOnData: travelOnData)
    }
}
