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
    private var kakaoService = KakaoAPIService()
    
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
    func deleteTravelOn(travelOnId: Int, onComplete: @escaping () -> ()) {
        return travelOnRepository.deleteTravelOn(travelOnId: travelOnId, onComplete: onComplete)
    }
    
    // 여행On 등록
	func postTravelOn(travelOnData: TravelOnPost, onComplete: @escaping (Int) -> Void) {
        travelOnRepository.postTravelOn(travelOnData: travelOnData, onComplete: onComplete)
    }
    
    // 여행On 수정
    func updateTravelOn(travelOnID: Int, travelOnData: TravelOnPost, onComplete: @escaping (Int) -> Void) {
        return travelOnRepository.updateTravelOn(travelOnId: travelOnID, travelOnData: travelOnData, onComplete: onComplete)
    }
	
	/// 여행 On의 지역과 주소의 지역이 같은지 검사합니다.
	func checkAddressWithTravelOn(travelOnId: Int, address: String, onComplete: @escaping (Bool) -> Void) {
		travelOnRepository.checkAddressWithTravelOn(travelOnId: travelOnId, address: address)
			.sink(
				receiveCompletion: { _ in },
				receiveValue: {
					onComplete($0.sameRegionAddress)
				}
			)
			.store(in: &cancelBag)
	}
}
