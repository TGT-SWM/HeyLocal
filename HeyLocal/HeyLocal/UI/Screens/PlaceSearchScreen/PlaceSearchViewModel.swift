//
//  PlaceSearchViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI

extension PlaceSearchScreen {
	class ViewModel: ObservableObject {
		// Dependencies
		let kakaoAPIService = KakaoAPIService()
		
		// States
		@Published var query = ""
		@Published var selectedItems = [Place]()
		@Published var searchedItems = [Place]()
		@Published var currentPage = 1
		@Published var isLastPage = false
		
		// 검색어가 바뀌고 검색 버튼이 눌리면,
		// currentPage를 1로 초기화하고
		// searchedItems를 비워야 함
		
		let pageSize = 15
		
		func search() {
			if query.isEmpty { return }
			
			// 초기화
			currentPage = 1
			searchedItems.removeAll()
			isLastPage = false
			
			// 검색
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
		
		func loadMore() {
			if query.isEmpty { return }
			if isLastPage { return }
			
			currentPage += 1
			
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
		
		func isSelected(_ item: Place) -> Bool {
			return self.selectedItems.contains(item)
		}
		
		func addSelectedItem(_ item: Place) {
			if !isSelected(item) {
				self.selectedItems.append(item)
			}
		}
		
		func removeSelectedItem(_ item: Place) {
			if let index = self.selectedItems.firstIndex(of: item) {
				self.selectedItems.remove(at: index)
			}
		}
	}
}
