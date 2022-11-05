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
		
		// 상태 (장소 상세 정보)
		@Published var placeDetail = PlaceDetail()
		
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


// MARK: - 장소 추가 정보 조회 기능

extension PlaceDetailScreen.ViewModel {
	/// 식당 또는 카페의 상세 정보를 조회합니다.
	func fetchDetailInfo() {
		placeService.getPlaceDetail(
			placeId: place.id,
			placeDetail: bind(\.placeDetail)
		)
	}
	
	/// 메뉴를 표시할 것인지의 여부를 반환합니다.
	/// 식당 또는 카페이면서, 불러온 메뉴가 있으면 메뉴를 표시합니다.
	var displayMenu: Bool {
		["FD6", "CE7"].contains(place.category) &&
		!placeDetail.menus.isEmpty
	}
	
	/// 장소의 운영 시간을 배열로 반환합니다.
	var openingTimes: [String] {
		placeDetail.businessTimes.map(\.openTime)
	}
	
	/// 장소의 메뉴를 배열로 반환합니다.
	var menus: [PlaceDetail.MenuInfo] {
		placeDetail.menus
	}
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
