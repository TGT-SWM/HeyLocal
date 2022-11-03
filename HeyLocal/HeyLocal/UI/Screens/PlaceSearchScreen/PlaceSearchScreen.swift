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
	@StateObject var viewModel = ViewModel()
	@Environment(\.dismiss) var dismiss
	
	// 지역 이름
	var regionName: String
	
	/// 장소 선택 완료 시 실행되는 콜백 함수
	var onComplete: ([Place]) -> Void
	
    var body: some View {
		VStack {
			searchForm
			selectedItemList
			searchedItemList
			completeButton
		}
		.navigationTitle("장소 검색")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				BackButton()
			}
		}
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
			if viewModel.searchedItems.isEmpty {
				recommendation
					.onAppear {
						viewModel.fetchRecommendedItems(regionName: regionName)
					}
			} else {
				LazyVStack(alignment: .center, spacing: 0) {
					// 검색 결과
					ForEach(viewModel.searchedItems, id: \.id) { listItem($0) }
					
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
	}
	
	func listItem(_ item: Place) -> some View {
		HStack(alignment: .center, spacing: 0) {
			// 썸네일
			WebImage(url: "https://www.busan.go.kr/resource/img/geopark/sub/busantour/busantour1.jpg")
				.frame(width: 56, height: 56)
				.cornerRadius(.infinity)
			
			// 텍스트
			VStack(alignment: .leading) {
				Text(item.name) // 이름
					.font(.system(size: 16))
					.fontWeight(.medium)
				Text("\(item.categoryName) | \(item.address)") // 주소
					.font(.system(size: 12))
					.foregroundColor(Color("gray"))
			}
			.padding(.leading, 12)
			
			Spacer()
			
			// 선택 버튼
			Button {
				viewModel.addSelectedItem(item)
			} label: {
				ZStack {
					RoundedRectangle(cornerRadius: 100)
						.fill(Color("orange"))
						.frame(width: 38, height: 20)
					Text("선택")
						.font(.system(size: 12))
						.foregroundColor(.white)
				}
			}
			.if(viewModel.isSelected(item)) {
				$0.disabled(true)
			}
		}
		.frame(height: 80)
		.padding(.horizontal, 21)
	}
}


// MARK: - recommendation (추천 장소 제안)

extension PlaceSearchScreen {
	// 추천 장소 뷰입니다.
	var recommendation: some View {
		VStack(spacing: 0) {
			HStack {
				Text("추천 장소")
					.font(.system(size: 14))
					.fontWeight(.medium)
					.foregroundColor(Color("gray"))
					.padding(.leading, 20)
				
				Spacer()
			}
			.frame(height: 40)
			
			Divider()
				.frame(maxWidth: .infinity)
				.overlay(Color("lightGray"))
			
			ForEach(viewModel.recommendedItems, id: \.id) { listItem($0) }
		}
	}
}


// MARK: - 선택 완료 버튼

extension PlaceSearchScreen {
	/// 장소 선택 완료 버튼입니다.
	var completeButton: some View {
		Button {
			handleComplete()
		} label: {
			ZStack {
				RoundedRectangle(cornerRadius: 22)
					.fill(Color("orange"))
					.frame(maxWidth: .infinity)
					.frame(height: 44)
				Text("장소 선택 완료")
					.foregroundColor(.white)
					.font(.system(size: 16))
					.fontWeight(.medium)
			}
			.padding(.horizontal, 20)
			.padding(.bottom, 46)
		}
	}
	
	/// 완료 버튼 클릭 시 이전 화면으로 Go Back
	func handleComplete() {
		onComplete(viewModel.selectedItems)
		dismiss()
	}
}


// MARK: - Previews

struct PlaceSearchScreen_Previews: PreviewProvider {
    static var previews: some View {
		PlaceSearchScreen(regionName: "서울특별시", onComplete: { places in })
    }
}
