//
//  PlaceList.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct PlaceList: View {
	@Binding var places: [Place]
	@Environment(\.placeListEditing) var placeListEditing
	
	@State var draggedItem: Place?
	
    var body: some View {
		VStack {
			ForEach(places.indices, id: \.self) { index in
				item(index: index, place: places[index])
					.onDrag {
						self.draggedItem = places[index]
						return NSItemProvider(item: nil, typeIdentifier: places[index].name)
					}
					.onDrop(of: [places[index].name], delegate: PlaceDropDelegate(currentItem: places[index], places: $places, draggedItem: $draggedItem, placeListEditing: placeListEditing))
			}
		}
		.animation(.easeInOut)
    }
	
	func item(index: Int, place: Place) -> some View {
		HStack {
			deleteButton(index: index)
			
			Text(String(index + 1))
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
			
			moveButton(index: index)
		}
		.padding(.horizontal)
	}
	
	func deleteButton(index: Int) -> some View {
		Group {
			if placeListEditing {
				Image(systemName: "minus.circle")
					.imageScale(.large)
					.foregroundColor(.red)
					.onTapGesture {
						places.remove(at: index)
					}
			}
		}
	}
	
	func moveButton(index: Int) -> some View {
		Group {
			if placeListEditing {
				Image(systemName: "equal")
					.imageScale(.large)
			}
		}
	}
}

struct PlaceDropDelegate: DropDelegate {
	let currentItem: Place
	@Binding var places: [Place]
	@Binding var draggedItem: Place?
	
	var placeListEditing: Bool
	
	// Drop 벗어났을때
	func dropExited(info: DropInfo) {
		
	}
	
	// Drop 처리
	func performDrop(info: DropInfo) -> Bool {
		return true
	}
	
	// Drop 변경
	func dropUpdated(info: DropInfo) -> DropProposal? {
		return DropProposal(operation: .move)
	}
	
	// Drop 유효 여부
	func validateDrop(info: DropInfo) -> Bool {
		return true
	}
	
	// Drop 시작
	func dropEntered(info: DropInfo) {
		if !placeListEditing { return }
		guard let draggedItem = self.draggedItem else { return }
		
		if draggedItem != currentItem {
			let from = places.firstIndex(of: draggedItem)!
			let to = places.firstIndex(of: currentItem)!
			withAnimation {
				self.places.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
			}
		}
	}
}

struct PlaceListEditing: EnvironmentKey {
	static let defaultValue = false
}

extension EnvironmentValues {
	var placeListEditing: Bool {
		get { self[PlaceListEditing.self] }
		set { self[PlaceListEditing.self] = newValue }
	}
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
		PlaceList(places: .constant([
			Place(id: 1, name: "해운대", address: "", roadAddress: "", lat: 0, lng: 0),
			Place(id: 2, name: "부산꼼장어", address: "", roadAddress: "", lat: 0, lng: 0),
			Place(id: 3, name: "감천 문화마을", address: "", roadAddress: "", lat: 0, lng: 0),
			Place(id: 4, name: "광안대교", address: "", roadAddress: "", lat: 0, lng: 0),
			Place(id: 5, name: "시그니엘 부산", address: "", roadAddress: "", lat: 0, lng: 0)
		]))
    }
}
