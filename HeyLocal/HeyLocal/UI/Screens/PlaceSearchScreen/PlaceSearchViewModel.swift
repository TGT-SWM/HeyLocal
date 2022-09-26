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
		
		func fetchSearchedItems() {
			if query.isEmpty { return }
			kakaoAPIService.loadPlaces(
				query: query,
				page: 1,
				pageSize: 15,
				places: Binding(
					get: { self.searchedItems },
					set: { self.searchedItems = $0 }
				)
			)
		}
	}
}
