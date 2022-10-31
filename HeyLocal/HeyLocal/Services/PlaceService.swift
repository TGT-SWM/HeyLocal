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
			receiveCompletion: { completion in
				switch completion {
				case .finished:
					print("finished")
				case .failure(let err):
					print(err)
				}
			},
			receiveValue: {
				opinions.wrappedValue.append(contentsOf: $0)
				lastItemId.wrappedValue = $0.last?.id
				
				if $0.isEmpty {
					isEnd.wrappedValue = true
				}
			}
		)
		.store(in: &cancelBag)
	}
}
