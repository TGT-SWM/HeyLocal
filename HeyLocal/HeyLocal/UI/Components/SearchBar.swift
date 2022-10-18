//
//  SearchBar.swift
//  HeyLocal
//  검색바 컴포넌트
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

/// 검색 바
struct SearchBar: View {
    var placeholder: String
    @Binding var searchText: String
	
	/// 검색 버튼이 눌렸을 때 실행할 콜백 함수
	var onSubmit: ((String) -> Void)?
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(placeholder, text: $searchText)
                .frame(width: 350, height: 36)
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                .cornerRadius(10)
            
			Button {
				if let onSubmit = onSubmit {
					onSubmit(searchText)
				}
			} label: {
				Image(systemName: "magnifyingglass")
					.foregroundColor(Color(red: 110 / 255, green: 108 / 255, blue: 106 / 255))
					.padding()
			}
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(placeholder: "", searchText: .constant(""))
    }
}
