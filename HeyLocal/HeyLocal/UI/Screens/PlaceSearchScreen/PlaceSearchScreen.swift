//
//  PlaceSearchScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlaceSearchScreen (장소 검색 화면)

struct PlaceSearchScreen: View {
	@ObservedObject var viewModel = ViewModel()
	
    var body: some View {
		VStack {
			searchForm
			selectedItemList
			searchedItemList
			recommendation
		}
		.navigationTitle("장소 검색")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			Button("완료") {}
		}
    }
}


// MARK: - searchForm (검색 폼)

extension PlaceSearchScreen {
	var searchForm: some View {
		HStack {
			TextField("검색어", text: $viewModel.query)
			Button("검색") {
				viewModel.fetchSearchedItems()
			}
		}
	}
}


// MARK: - selectedItemList (선택한 장소 목록)

extension PlaceSearchScreen {
	var selectedItemList: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(viewModel.selectedItems, id: \.id) { selectedItem($0) }
			}
		}
	}
	
	func selectedItem(_ item: Place) -> some View {
		HStack {
			Text(item.name)
		}
	}
}


// MARK: - searchedItemList (검색 결과)

extension PlaceSearchScreen {
	var searchedItemList: some View {
		ScrollView {
			VStack(alignment: .leading) {
				ForEach(viewModel.searchedItems, id: \.id) { searchedItem($0) }
			}
		}
	}
	
	func searchedItem(_ item: Place) -> some View {
		HStack {
			Text(item.name)
		}
	}
}


// MARK: - recommendation (추천 장소 제안)

extension PlaceSearchScreen {
	var recommendation: some View {
		VStack {
			Text("이런 곳은 어떤가요?")
		}
	}
}

struct PlaceSearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlaceSearchScreen()
    }
}
