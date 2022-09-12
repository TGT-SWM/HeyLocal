//
//  ToggleButtonStyle.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ToggleButtonStyle: ButtonStyle {
    @Binding var value: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
            .font(.system(size: 18))
            .foregroundColor(Color.black)
            .background(value ? Color(red: 255 / 255, green: 209 / 255, blue: 120 / 255) : Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
            .cornerRadius(90)
    }
}
