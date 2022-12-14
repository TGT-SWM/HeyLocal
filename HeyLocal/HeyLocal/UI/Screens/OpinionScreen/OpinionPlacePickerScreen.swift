//
//  OpinionPlacePickerScreen.swift
//  HeyLocal
//  답변 작성 시, 장소 선택 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionPlacePickerScreen: View {
    @Environment(\.dismiss) private var dismiss
	let travelOnService = TravelOnService()
	
    var btnBack : some View { Button(action: {
        dismiss()
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .foregroundColor(.black)
        }
    }
    
	var travelOnId: Int
    @Binding var place: Place
	
    @ObservedObject var viewModel = PlaceSearchScreen.ViewModel()
	@State var showModal = false
	
    var body: some View {
		ZStack {
			VStack(alignment: .leading) {
				SearchBar(placeholder: "", searchText: $viewModel.query) { _ in
					viewModel.search()
				}
					.padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 0))
				
				ZStack(alignment: .bottom) {
					ScrollView {
						content
					}
				}
			}
			
			if showModal {
				ConfirmModal(
					title: "안내",
					message: "여행 On과 같은 지역의 장소만 추천할 수 있어요.",
					showModal: $showModal
				)
			}
		}
        .navigationTitle("장소 선택")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
    
    var content: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            ForEach(viewModel.searchedItems, id: \.id) { searchedItem($0) }

            if (!viewModel.isLastPage) {
                ProgressView()
                    .onAppear {
                        viewModel.searchNextPage()
                    }
            }
            
        }
    }
    
    func searchedItem(_ item: Place) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Button(action: {
				travelOnService.checkAddressWithTravelOn(travelOnId: travelOnId, address: item.address) { isSame in
					if isSame {
						self.place = item
						dismiss()
					} else {
						showModal = true
					}
				}
            }) {
                // 썸네일
                if let imageURL = item.thumbnailUrl {
                    AsyncImage(url: URL(string: imageURL))
                        .frame(width: 56, height: 56)
                        .cornerRadius(.infinity)
                } else {
                    Circle()
                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        .frame(width: 56, height: 56)
                }
                
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
                
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color("orange"))
                        .frame(width: 40, height: 22)
                    Text("선택")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
            }
            .foregroundColor(.black)
			
            
//            // 선택 버튼
//            Button {
//                self.place = item
//                print("\(item.address)")
//                dismiss()
//            } label: {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 100)
//                        .fill(Color("orange"))
//                        .frame(width: 40, height: 22)
//                    Text("선택")
//                        .font(.system(size: 12))
//                        .foregroundColor(.white)
//                }
//            }
        }
        .frame(height: 80)
        .padding(.horizontal, 21)
    }
}
