//
//  PlaceService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class PlaceService {
    private var placeRepository = PlaceRepository()
	let kakaoAPIService = KakaoAPIService()
	
	var cancelBag: Set<AnyCancellable> = []
    
    // Hot한 장소
    func getHotPlaces() -> AnyPublisher<[Place], Error> {
        return placeRepository.getHotPlaces()
    }
    
	/// 장소에 대해 작성된 답변들을 조회합니다.
	func getOpinions(placeId: Int, lastItemId: Binding<Int?>, size: Int, opinions: Binding<[Opinion]>, isEnd: Binding<Bool>) {
		placeRepository.getOpinions(
			placeId: placeId,
			lastItemId: lastItemId.wrappedValue,
			size: size
		)
		.sink(
			receiveCompletion: { _ in
				for i in opinions.indices {
					self.kakaoAPIService.getPlaceImage(place: opinions[i].place)
				}
			},
			receiveValue: {
				opinions.wrappedValue.append(contentsOf: $0)
				lastItemId.wrappedValue = $0.last?.id
				
				if $0.count < size {
					isEnd.wrappedValue = true
				}
			}
		)
		.store(in: &cancelBag)
	}
	
	/// 장소의 상세 정보들을 조회합니다.
	func getPlaceDetail(placeId: Int, placeDetail: Binding<PlaceDetail>) {
		placeRepository.getPlaceDetail(placeId: placeId)
			.sink(
				receiveCompletion: { completion in
					print(completion) // LOG
				},
				receiveValue: {
					placeDetail.wrappedValue = $0
				}
			)
			.store(in: &cancelBag)
	}
}
