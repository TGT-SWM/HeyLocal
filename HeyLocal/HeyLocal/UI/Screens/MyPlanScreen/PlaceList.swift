//
//  PlaceList.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlaceList (장소 리스트)

struct PlaceList: View {
	var places: [Place]
	
    var body: some View {
		VStack {
			if (places.isEmpty) {
				Text("등록된 장소가 없습니다. 장소를 추가해보세요.")
			} else {
				placeList
			}
		}
    }
}


// MARK: - placeList

extension PlaceList {
	var placeList: some View {
		List(places.indices, id: \.self) { idx in
			listItem(order: idx, place: places[idx])
		}
	}
	
	func listItem(order: Int, place: Place) -> some View {
		HStack(alignment: .center) {
			Text(String(order + 1))
				.fontWeight(.bold)
				.padding()
				.background(
					Circle()
						.frame(width: 32, height: 32)
						.foregroundColor(Color("lightGray"))
				)
			
			VStack(alignment: .leading) {
				Text(place.name) // 이름
					.font(.title3)
					.fontWeight(.bold)
				Text("\(place.categoryName) | \(place.address)") // 주소
					.font(.subheadline)
			}
			
			Spacer()
		}
		.frame(height: 70)
	}
}


// MARK: - Previews

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        PlaceList(places: [
			Place(id: 1, name: "해운대", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: ""),
			Place(id: 2, name: "부산꼼장어", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: ""),
			Place(id: 3, name: "감천 문화마을", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: ""),
			Place(id: 4, name: "광안대교", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: ""),
			Place(id: 5, name: "시그니엘 부산", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: "")
		])
    }
}
