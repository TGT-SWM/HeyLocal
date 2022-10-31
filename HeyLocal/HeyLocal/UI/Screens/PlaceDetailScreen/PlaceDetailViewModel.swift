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
		@Published var menus: [PlaceMenu] = []
		
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
		// TODO: API 연동하여 아래 대체할 것
		menus = [
			PlaceMenu(name: "메뉴 A", price: "13,500원"),
			PlaceMenu(name: "메뉴 B", price: "12,500원"),
			PlaceMenu(name: "메뉴 C", price: "9,000원"),
			PlaceMenu(name: "메뉴 D", price: "9,500원"),
			PlaceMenu(name: "메뉴 E", price: "10,000원"),
			PlaceMenu(name: "메뉴 F", price: "26,000원"),
			PlaceMenu(name: "메뉴 G", price: "50,000원"),
		]
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
