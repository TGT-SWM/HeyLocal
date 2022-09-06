//
//  SearchBar.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

/// 검색 바
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .textFieldStyle(.roundedBorder)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar("검색", text: .constant(""))
    }
}
