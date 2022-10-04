//
//  ToggleButtonStyle.swift
//  HeyLocal
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
            .foregroundColor(value ? Color(red: 255/255, green: 153/255, blue: 0/255) : Color(red: 121/255, green: 119/255, blue: 117/255))
            .overlay(RoundedRectangle(cornerRadius: 100.0).strokeBorder(value ? Color(red: 255/255, green: 153/255, blue: 0/255) : Color(red: 121/255, green: 119/255, blue: 117/255), style: StrokeStyle(lineWidth: 1.0)))
            .cornerRadius(100)
    }
}
