//
//  AlertCustomButton.swift
//  HeyLocal
//  커스텀 Alert 창의 버튼 스타일
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct AlertCustomButton: ButtonStyle {
    @State var value: Bool
    @State var width: Int
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: CGFloat(width), height: 34)
            .font(.system(size: 14))
            .foregroundColor(value ? Color.white : Color(red: 121/255, green: 119/255, blue: 117/255))
            .background(value ? Color(red: 255/255, green: 153/255, blue: 0/255) : .white)
            .overlay(RoundedRectangle(cornerRadius: 100.0).strokeBorder(value ? Color(red: 255/255, green: 153/255, blue: 0/255) : Color(red: 121/255, green: 119/255, blue: 117/255), style: StrokeStyle(lineWidth: 1.0)))
            .cornerRadius(100)
    }
}
