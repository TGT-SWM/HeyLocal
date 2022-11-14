//
//  RegionPickerScreen.swift
//  HeyLocal
//  지역선택 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct RegionPickerScreen: View {
    @State var regionName: String = ""
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayTabBar) var displayTabBar
    @Binding var regionID: Int?
    var forSort: Bool

    
    var body: some View {
        VStack(alignment: .leading) {
            // 검색바
            SearchBar(placeholder: "", searchText: $regionName)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            // 지역 component 출력
            ScrollView {
                VStack(alignment: .leading) {
                    if forSort {
                        RegionComponent(region: nil)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 160))
                            .simultaneousGesture(TapGesture().onEnded{
                                regionID = nil
                                dismiss()
                            })
                    }
                    
                    ForEach(viewModel.regions.filter({"\($0)".contains(self.regionName) || self.regionName.isEmpty}), id: \.self) { region in
                        RegionComponent(region: region)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 160))
                            .simultaneousGesture(TapGesture().onEnded{
                                regionID = region.id
                                dismiss()
                            })
                    }
                }
            }
        }
        .onAppear {
            displayTabBar(false)
            viewModel.fetchRegions()
        }
        .navigationTitle("여행지 선택")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton() )
    }
}

struct RegionPickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegionPickerScreen(regionID: .constant(259), forSort: false)
    }
}
