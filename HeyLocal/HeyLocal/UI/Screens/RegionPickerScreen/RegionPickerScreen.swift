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
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchBar(placeholder: "", searchText: $regionName)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.regions.filter({"\($0)".contains(self.regionName) || self.regionName.isEmpty}), id: \.self) { region in
                        RegionComponent(region: region)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 150))
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchRegions()
        }
    }
}

struct RegionPickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegionPickerScreen()
    }
}
