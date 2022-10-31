//
//  ToggleButtonStyle.swift
//  HeyLocal
//  값 선택 버튼 (여행On·답변 등록 시 사용)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ToggleButtonStyle: ButtonStyle {
    @Binding var value: Bool
    @State var width: Int
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: CGFloat(width), height: 34)
            .font(.system(size: 14))
            .foregroundColor(value ? Color("orange") : Color("gray"))
            .background(value ?  Color(red: 255/255, green: 248/255, blue: 235/255) : .clear)
            .overlay(RoundedRectangle(cornerRadius: 100.0).strokeBorder(value ? Color("orange") : Color("gray"), style: StrokeStyle(lineWidth: 1.0)))
    }
}
