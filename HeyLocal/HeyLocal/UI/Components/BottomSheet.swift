//
//  BottomSheet.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
	@Binding var showSheet: Bool
	var content: () -> Content
	
	init(showSheet: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
		self._showSheet = showSheet
		self.content = content
	}
	
    var body: some View {
		ZStack(alignment: .bottom) {
			// 배경
			Color.black.opacity(0.15)
				.onTapGesture {
					showSheet = false
				}
			
			// 모달
			VStack(alignment: .leading, spacing: 0) {
				content()
				HStack { Spacer() }
			}
			.frame(maxWidth: .infinity)
			.padding(.top, 16)
			.padding(.bottom, 60)
			.padding(.horizontal, 20)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(.white)
					.shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
					.shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
					.frame(maxWidth: .infinity)
			)
		}
		.edgesIgnoringSafeArea(.all)
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
		BottomSheet(showSheet: .constant(true)) {
			Text("날짜선택")
				.font(.system(size: 14))
				.fontWeight(.medium)
				.padding(.bottom)
			
			VStack {
				ForEach(0..<5) {
					Text("DAY \($0 + 1)")
						.font(.system(size: 16))
						.fontWeight(.medium)
						.padding(.bottom)
				}
			}
		}
    }
}
