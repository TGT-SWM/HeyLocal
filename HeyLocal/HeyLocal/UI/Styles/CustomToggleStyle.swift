//
//  CustomToggleStyle.swift
//  HeyLocal
//  커스텀한 토글 스타일 (답변 있는 게시글만 보기)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
                .frame(width: 3)
            Rectangle()
                .foregroundColor(configuration.isOn ? Color(red: 255/255, green: 153/255, blue: 0/255) : Color(red: 117/255, green: 118/255, blue: 121/255))
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 10)
                        .padding(.all, 3)
                        .offset(x: configuration.isOn ? 7 : -7, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                        
                )
                .frame(width: 26, height: 12)
                .cornerRadius(12)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

