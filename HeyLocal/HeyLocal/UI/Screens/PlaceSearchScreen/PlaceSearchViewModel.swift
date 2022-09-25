//
//  PlaceSearchViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

extension PlaceSearchScreen {
	class ViewModel: ObservableObject {
		// States
		@Published var query = ""
		@Published var selectedItems = [Place]()
		@Published var searchedItems = [Place]()
		
		func fetchSearchedItems() { }
	}
}
