//
//  PlanDetailScreenViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI

extension PlanDetailScreen {
	class ViewModel: ObservableObject {
		@Published var showMapView = false
		@Published var currentDay = 1
		@Published var places: [[Place]] = [[]]
		
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
		
		/// 현재 일자에 해당하는 장소 배열
		var currentDayPlaces: [Place] {
			places[currentDay - 1]
		}
		
		/// 현재 일자가 여행 첫째 날인지
		var isFirstDay: Bool {
			currentDay == 1
		}
		
		/// 현재 일자가 여행 마지막 날인지
		var isLastDay: Bool {
			currentDay == places.count
		}
		
		/// 다음 일자로 이동
		func goNextDay() {
			currentDay = min(currentDay + 1, places.count)
		}
		
		/// 이전 일자로 이동
		func goPrevDay() {
			currentDay = max(currentDay - 1, 1)
		}
	}
}
