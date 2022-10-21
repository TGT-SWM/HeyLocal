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
	var onComplete: ((Place?, Place?, Place?)) -> Void
	
	var restaurants: [Place] {
		places.filter {
			["FD6", "CE7"].contains($0.category) // 식당 OR 카페
		}
	}
	
	@State var selected: (Place?, Place?, Place?) = (nil, nil, nil)
	
    var body: some View {
		VStack {
			mealPicker(title: "아침", selection: $selected.0)
			mealPicker(title: "점심", selection: $selected.1)
			mealPicker(title: "저녁", selection: $selected.2)
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
				ForEach(restaurants) {
					Text($0.name)
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
					onComplete(selected)
					dismiss()
				}
			}
		}
	}
}

struct MealSelectScreen_Previews: PreviewProvider {
    static var previews: some View {
		MealSelectScreen(places: [], onComplete: { selected in })
    }
}
