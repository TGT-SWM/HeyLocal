//
//  PlaceSearchScreen.swift
//  HeyLocal
//	장소 검색 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlaceSearchScreen (장소 검색 화면)

struct PlaceSearchScreen: View {
	@ObservedObject var viewModel = ViewModel()
	@Environment(\.dismiss) var dismiss
	
	/// 장소 선택 완료 시 실행되는 콜백 함수
	var onComplete: ([Place]) -> Void
	
    var body: some View {
		VStack {
			searchForm
			selectedItemList
			searchedItemList
			// recommendation
		}
		.navigationTitle("장소 검색")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			Button("완료", action: handleComplete)
		}
    }
	
	/// 완료 버튼 클릭 시 이전 화면으로 Go Back
	func handleComplete() {
		onComplete(viewModel.selectedItems)
		dismiss()
	}
}


// MARK: - searchForm (검색 폼)

extension PlaceSearchScreen {
	var searchForm: some View {
		SearchBar(placeholder: "", searchText: $viewModel.query) { _ in
			viewModel.search()
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
		.padding(.horizontal)
	}
	
	func selectedItem(_ item: Place) -> some View {
		ZStack(alignment: .topTrailing) {
			VStack(alignment: .center) {
				RoundedRectangle(cornerRadius: 5) // 썸네일 이미지
					.fill(.gray)
					.frame(width: 50, height: 50)
				Text(item.name) // 이름
					.font(.subheadline)
			}
			.frame(width: 50, height: 70)
			
			Button { // 선택 취소 버튼
				viewModel.removeSelectedItem(item)
			} label: {
				Image(systemName: "x.circle.fill")
			}
		}
		.frame(width: 60, height: 80)
	}
}


// MARK: - searchedItemList (검색 결과)

extension PlaceSearchScreen {
	var searchedItemList: some View {
		ScrollView {
			LazyVStack(alignment: .center) {
				// 검색 결과
				ForEach(viewModel.searchedItems, id: \.id) { searchedItem($0) }
				
				// 스피너가 노출되면 다음 페이지 로드
				if (!viewModel.isLastPage) {
					ProgressView()
						.onAppear {
							viewModel.searchNextPage()
						}
				}
			}
		}
	}
	
	func searchedItem(_ item: Place) -> some View {
		HStack(alignment: .center) {
			RoundedRectangle(cornerRadius: 5) // 썸네일 이미지
				.fill(.gray)
				.frame(width: 50, height: 50)
			
			VStack(alignment: .leading) {
				Text(item.name) // 이름
					.font(.title3)
					.fontWeight(.bold)
				Text("\(item.categoryName) | \(item.address)") // 주소
					.font(.subheadline)
			}
			
			Spacer()
			
			if (viewModel.isSelected(item)) {
				Button("선택") {}
					.disabled(true)
			} else {
				Button("선택") { // 장소 선택 버튼
					viewModel.addSelectedItem(item)
				}
			}
		}
		.frame(height: 70)
		.padding(.horizontal)
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
		PlaceSearchScreen(onComplete: { places in })
    }
}
