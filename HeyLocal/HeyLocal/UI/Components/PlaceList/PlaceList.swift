//
//  PlaceList.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct PlaceList: View {
	var planId: Int
	@ObservedObject var viewModel = ViewModel()
	
    var body: some View {
		VStack {
			if (viewModel.currentPlaces.isEmpty) {
				Text("등록된 장소가 없습니다. 장소를 추가해보세요.")
			} else {
				ForEach(viewModel.currentPlaces.indices, id: \.self) { idx in
					listItem(order: idx, place: viewModel.currentPlaces[idx])
				}
			}
		}
		.onAppear {
			viewModel.fetchPlaces()
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
        PlaceList(planId: 1)
    }
}
