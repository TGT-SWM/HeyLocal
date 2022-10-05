//
//  SNSButtonStyle.swift
//  HeyLocal
//  소셜 로그인·회원가입 버튼 스타일
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// SNS Button Style
struct SNSButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: ScreenSize.width * 0.9, height: 50)
            .font(.system(size: 16))
            .background(Color(red: 217/255, green: 217/255, blue: 217/255))
    }
}
