//
//  MealSelectScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - MealSelectScreen (식사 선택 화면)

struct MealSelectScreen: View {
	@Environment(\.dismiss) var dismiss

	var places: [Place]
	var onComplete: ([Place?]) -> Void

	var restaurants: [Place] {
		places.filter {
			["FD6", "CE7"].contains($0.category) // 식당 OR 카페
		}
	}

	@State var breakfast: Place?
	@State var lunch: Place?
	@State var dinner: Place?

	var body: some View {
		VStack {
			mealPicker(title: "아침", selection: $breakfast)
			mealPicker(title: "점심", selection: $lunch)
			mealPicker(title: "저녁", selection: $dinner)
		}
		.navigationTitle("최적루트 재정렬")
		.navigationBarBackButtonHidden(true)
		.toolbar { toolbarItems }
	}

	func mealPicker(title: String, selection: Binding<Place?>) -> some View {
		VStack {
			Text(title)
			Picker(title, selection: selection) {
				Text("없음").tag(Optional<Place>(nil))
				ForEach(restaurants, id: \.id) {
					Text($0.name).tag($0 as Place?)
				}
			}
		}
	}

	var toolbarItems: some ToolbarContent {
		Group {
			ToolbarItem(placement: .navigationBarLeading) {
				BackButton()
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("완료") {
					onComplete([breakfast, lunch, dinner])
					dismiss()
				}
			}
		}
	}
}


// MARK: - Previews

struct MealSelectScreen_Previews: PreviewProvider {
	static var previews: some View {
		MealSelectScreen(places: [], onComplete: { selected in })
	}
}
