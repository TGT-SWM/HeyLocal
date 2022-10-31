//
//  PlaceDetailViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - PlaceDetailScreen.ViewModel (뷰 모델)

extension PlaceDetailScreen {
	class ViewModel: ObservableObject {
		// 의존성
		let placeService = PlaceService()
		
		// 상태 (답변 리스트)
		@Published var opinions: [Opinion] = []
		@Published var lastItemId: Int?
		@Published var isEnd = false
		let opinionLoadSize = 15
		
		// 파라미터
		var place: Place
		
		init(place: Place) {
			self.place = place
		}
	}
}


// MARK: - 장소 크롤링 정보 조회 기능

extension PlaceDetailScreen.ViewModel {
	
}


// MARK: - 장소에 대한 답변 리스트 조회 기능

extension PlaceDetailScreen.ViewModel {
	/// 장소에 대해 작성된 답변들을 조회합니다.
	func fetchOpinions() {
		placeService.getOpinions(
			placeId: place.id,
			lastItemId: bind(\.lastItemId),
			size: opinionLoadSize,
			opinions: bind(\.opinions),
			isEnd: bind(\.isEnd)
		)
	}
}
