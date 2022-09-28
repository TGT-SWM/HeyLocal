//
//  PlaceSearchViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - PlaceSearchScreen.ViewModel (뷰 모델)

extension PlaceSearchScreen {
	class ViewModel: ObservableObject {
		let kakaoAPIService = KakaoAPIService() // 의존성
		
		@Published var query = "" // 검색어
		@Published var searchedItems = [Place]() // 검색 결과
		@Published var currentPage = 1 // 현재까지 로드한 페이지
		@Published var isLastPage = true // 마지막 페이지에 도달했는지
		let pageSize = 15 // 한 페이지당 아이템 개수
		
		@Published var selectedItems = [Place]() // 선택된 장소들
	}
}


// MARK: - 장소 검색 기능

extension PlaceSearchScreen.ViewModel {
	/// 카카오 로컬 API를 통해 장소를 검색합니다.
	/// 검색 결과는 기존 self.places의 끝에 추가됩니다.
	private func fetchSearchedItems() {
		kakaoAPIService.loadPlaces(
			query: query,
			page: currentPage,
			pageSize: pageSize,
			places: Binding(
				get: { self.searchedItems },
				set: { self.searchedItems = $0 }
			),
			isLastPage: Binding(
				get: { self.isLastPage },
				set: { self.isLastPage = $0 }
			)
		)
	}
	
	/// 장소를 검색합니다.
	/// 기존 검색 결과를 초기화하고 새로운 검색 결과를 받아와 저장합니다.
	func search() {
		if query.isEmpty { return }
		
		// 초기화
		currentPage = 1
		searchedItems.removeAll()
		isLastPage = false
		
		// 검색
		fetchSearchedItems()
	}
	
	/// 장소를 검색합니다.
	/// 다음 페이지의 검색 결과를 받아와 기존 검색 결과의 끝에 추가합니다.
	func searchNextPage() {
		if query.isEmpty { return }
		if isLastPage { return }
		
		currentPage += 1
		
		fetchSearchedItems()
	}
}


// MARK: - 장소 선택 기능

extension PlaceSearchScreen.ViewModel {
	/// 해당 장소가 선택된 상태인지의 여부를 반환합니다.
	func isSelected(_ item: Place) -> Bool {
		return self.selectedItems.contains(item)
	}
	
	/// 해당 장소가 선택되어 있지 않다면, 선택합니다.
	func addSelectedItem(_ item: Place) {
		if !isSelected(item) {
			self.selectedItems.append(item)
		}
	}
	
	/// 해당 장소에 대한 선택을 취소합니다.
	func removeSelectedItem(_ item: Place) {
		if let index = self.selectedItems.firstIndex(of: item) {
			self.selectedItems.remove(at: index)
		}
	}
}
