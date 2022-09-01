//
//  PlaceListViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

extension PlaceList {
	class ViewModel: ObservableObject {
		@Published var places: [[Place]] = [[]]
		@Published var currentDay = 0
		
		func fetchPlaces() {
			places = [
				// 1일차
				[
					Place(id: 1, name: "해운대"),
					Place(id: 2, name: "부산꼼장어"),
					Place(id: 3, name: "감천 문화마을"),
					Place(id: 4, name: "광안대교"),
					Place(id: 5, name: "시그니엘 부산")
				],
				// 2일차
				[
					Place(id: 5, name: "시그니엘 부산"),
					Place(id: 1, name: "해운대"),
					Place(id: 8, name: "해운대 돼지국밥"),
					Place(id: 1, name: "해운대"),
					Place(id: 8, name: "해운대 돼지국밥"),
					Place(id: 5, name: "시그니엘 부산")
				],
				// 3일차
				[
					Place(id: 5, name: "시그니엘 부산"),
					Place(id: 1, name: "해운대"),
					Place(id: 13, name: "부산터미널")
				
				]
			]
		}
		
		var currentPlaces: [Place] {
			places[currentDay]
		}
	}
}
