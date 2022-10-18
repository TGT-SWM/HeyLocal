//
//  OpinionPlacePickerScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionPlacePickerScreen: View {
    @Environment(\.dismiss) private var dismiss
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
    
    @Binding var place: Place
    @ObservedObject var viewModel = PlaceSearchScreen.ViewModel()
    var body: some View {
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
                self.place = item
                dismiss()
//                viewModel.addSelectedItem(item)
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
//            .if(viewModel.isSelected(item)) {
//                $0.disabled(true)
//            }
        }
        .frame(height: 80)
        .padding(.horizontal, 21)
    }
}
