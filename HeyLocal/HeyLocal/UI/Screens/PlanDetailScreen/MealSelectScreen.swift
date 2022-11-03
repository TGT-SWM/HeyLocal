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

	// 선택된 장소
	@State var breakfast: Place?
	@State var lunch: Place?
	@State var dinner: Place?

	var body: some View {
		VStack(spacing: 0) {
			header
			mealPicker(title: "아침", selection: $breakfast)
			mealPicker(title: "점심", selection: $lunch)
			mealPicker(title: "저녁", selection: $dinner)
			Color("lightgray")
				.frame(maxHeight: .infinity)
		}
		.navigationTitle("최적루트 재정렬")
		.navigationBarBackButtonHidden(true)
		.toolbar { toolbarItems }
	}
	
	var header: some View {
		HStack {
			VStack(alignment: .leading, spacing: 8) {
				Text("최적루트 설정")
					.font(.system(size: 16))
					.fontWeight(.medium)
				Text("최적루트로 재정렬하기 위해 식사장소를 선택해주세요")
					.font(.system(size: 14))
					.fontWeight(.medium)
					.foregroundColor(Color("gray"))
			}
			.padding(.leading, 20)
			
			Spacer()
		}
		.frame(height: 80)
		.background(Color.white)
	}

	func mealPicker(title: String, selection: Binding<Place?>) -> some View {
		VStack(spacing: 0) {
			Divider()
				.frame(minHeight: 8)
				.frame(maxWidth: .infinity)
				.overlay(Color("lightGray"))
			
			HStack(alignment: .center) {
				Text("\(title)식사 장소 선택")
					.font(.system(size: 14))
					.fontWeight(.medium)
					.foregroundColor(Color("gray"))
			}
			.frame(height: 48)
			
			Divider()
				.frame(maxWidth: .infinity)
				.overlay(Color("lightGray"))
			
			HStack(alignment: .center) {
				Picker(title, selection: selection) {
					Text("없음").tag(Optional<Place>(nil))
					ForEach(restaurants, id: \.id) {
						pickerItem(place: $0).tag($0 as Place?)
					}
				}
			}
			.frame(height: 72)
		}
		.background(Color.white)
	}
	
	func pickerItem(place: Place) -> some View {
		HStack {
			Text(place.name)
				.font(.system(size: 16))
				.fontWeight(.medium)
		}
	}

	var toolbarItems: some ToolbarContent {
		Group {
			ToolbarItem(placement: .navigationBarLeading) {
				BackButton()
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					onComplete([breakfast, lunch, dinner])
					dismiss()
				} label: {
					Text("완료")
						.font(.system(size: 16))
						.fontWeight(.medium)
						.foregroundColor(Color(red: 126 / 255, green: 0, blue: 217 / 255))
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
