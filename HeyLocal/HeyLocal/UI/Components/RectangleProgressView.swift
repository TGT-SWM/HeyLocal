//
//  RectangleProgressView.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - RectangleProgressView

/// 사각형 모양의 로딩 스피너 컴포넌트입니다.
struct RectangleProgressView: View {
    var body: some View {
		ZStack(alignment: .center) {
			RoundedRectangle(cornerRadius: 10)
				.fill(.black.opacity(0.3))
				.frame(width: 100, height: 100)
			ProgressView()
				.scaleEffect(1.5, anchor: .center)
				.progressViewStyle(CircularProgressViewStyle(tint: Color.white))
		}
    }
}


// MARK: - Previews

struct RectangleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleProgressView()
    }
}
