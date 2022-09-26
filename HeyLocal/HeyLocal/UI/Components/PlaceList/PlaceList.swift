//
//  PlaceList.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct PlaceList: View {
	var places: [Place]
	
    var body: some View {
		VStack {
			if (places.isEmpty) {
				Text("등록된 장소가 없습니다. 장소를 추가해보세요.")
			} else {
				ForEach(places.indices, id: \.self) { idx in
					listItem(order: idx, place: places[idx])
				}
			}
		}
    }
	
	func listItem(order: Int, place: Place) -> some View {
		HStack {
			Text(String(order + 1))
				.fontWeight(.bold)
				.padding()
				.background(
					Circle()
						.frame(width: 32, height: 32)
						.foregroundColor(.gray)
				)
			
			Text(place.name)
				.font(.title3)
				.fontWeight(.bold)
			Spacer()
		}
	}
}

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
