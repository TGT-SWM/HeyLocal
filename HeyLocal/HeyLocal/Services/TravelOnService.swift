//
//  TravelOnService.swift
//  HeyLocal
//  여행On 서비스
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class TravelOnService {
    private var travelOnRepository = TravelOnRepository()
    var cancelBag: Set<AnyCancellable> = []
    // 전체 여행On 조회
    func getTravelOnLists(lastItemId: Int?, pageSize: Int, keyword: String?, regionId: Int?, sortBy: String, withOpinions: Bool?) -> AnyPublisher<[TravelOn], Error> {
        return travelOnRepository.getTravelOnLists(lastItemId: lastItemId,
                                                   pageSize: pageSize,
                                                   keyword: keyword,
                                                   regionId: regionId,
                                                   sortBy: sortBy,
                                                   withOpinions: withOpinions)
    }
    
    
    // 전체 여행On 조회 with 페이징
    func getTravelOns(lastItemId: Binding<Int?>, pageSize: Int, keyword: String?, regionId: Int?, sortBy: String, withOpinions: Bool?, isEnd: Binding<Bool>, travelOns: Binding<[TravelOn]>) {
        travelOnRepository.getTravelOnLists(lastItemId: lastItemId.wrappedValue,
                                    pageSize: pageSize,
                                    keyword: keyword,
                                    regionId: regionId,
                                    sortBy: sortBy,
                                    withOpinions: withOpinions)
        .sink(
            receiveCompletion: { _ in },
            receiveValue: {
                travelOns.wrappedValue.append(contentsOf: $0)
                lastItemId.wrappedValue = $0.last?.id

                if $0.count < pageSize {
                    isEnd.wrappedValue = true
                }
            }
        )
        .store(in: &cancelBag)
    }
    
    // 여행On 상세 조회
    func getTravelOn(travelOnId: Int) -> AnyPublisher<TravelOn, Error> {
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
