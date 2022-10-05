//
//  BasicButtonStyle.swift
//  HeyLocal
//  로그인/회원가입/인증/중복확인, 이전/다음 버튼 스타일
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// Basic Button Style 구조체 : 로그인/회원가입/인증/중복확인, 이전/다음
struct BasicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 40)
            .font(.system(size: 16))
            .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
            .cornerRadius(6.0)
    }
}
