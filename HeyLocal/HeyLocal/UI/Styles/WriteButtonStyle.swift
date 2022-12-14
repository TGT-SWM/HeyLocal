//
//  WriteButtonStyle.swift
//  HeyLocal
//  글쓰기 버튼 스타일
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct WriteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.largeTitle))
            .frame(width: 57, height: 50)
            .foregroundColor(Color.white)
            .padding(.bottom, 7)
            .background(Color(red: 255 / 255, green: 153 / 255, blue: 0 / 255))
            .cornerRadius(38.5)
            .padding()
            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
    }
}
