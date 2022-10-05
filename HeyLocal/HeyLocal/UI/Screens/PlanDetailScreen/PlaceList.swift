//
//  PlaceList.swift
//  HeyLocal
//	일정의 장소 리스트 뷰
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlaceList (장소 리스트)

struct PlaceList: View {
	@Binding var places: [Place]
	
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


// MARK: - placeList (장소 리스트)

extension PlaceList {
	/// 장소를 출력하는 리스트입니다.
	var placeList: some View {
		List {
			ForEach(places.indices, id: \.self) { idx in
				listItem(order: idx, place: places[idx])
			}
			.onDelete(perform: handleDelete)
			.onMove(perform: handleMove)
		}
	}
	
	/// 리스트의 항목 뷰를 반환합니다.
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
				if let arrivalTime = place.arrivalTime {
					Text("\(arrivalTime) 도착")
				}
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
	
	/// 리스트 항목의 삭제 이벤트를 처리합니다.
	func handleDelete(indexSet: IndexSet) {
		places.remove(atOffsets: indexSet)
	}
	
	/// 리스트 항목의 순서 이동 이벤트를 처리합니다.
	func handleMove(from: IndexSet, to: Int) {
		places.move(fromOffsets: from, toOffset: to)
	}
}


// MARK: - Previews

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
		PlaceList(places: .constant([
			Place(id: 1, name: "해운대", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: ""),
			Place(id: 2, name: "부산꼼장어", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: ""),
			Place(id: 3, name: "감천 문화마을", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: ""),
			Place(id: 4, name: "광안대교", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: ""),
			Place(id: 5, name: "시그니엘 부산", category: "FD6", address: "", roadAddress: "", lat: 0, lng: 0, link: "")
		]))
    }
}
