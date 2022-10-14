//
//  OpinionPlacePickerScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionPlacePickerScreen: View {
    @Binding var place: Place?
    @State var placeName: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            SearchBar(placeholder: "", searchText: $placeName)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            ZStack(alignment: .bottom) {
                ScrollView {
                    content
                        .padding()
                }
            }
        }
        .navigationTitle("장소 선택")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    var content: some View {
        VStack {
            Text("ddddd")
        }
    }
}

struct OpinionPlacePickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpinionPlacePickerScreen(place: .constant(nil))
    }
}
