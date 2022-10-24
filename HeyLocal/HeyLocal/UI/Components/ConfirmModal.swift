//
//  ConfirmModal.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - ConfirmModal (확인 모달)

/// 사용자의 확인을 구하기 위한 모달 뷰입니다.
struct ConfirmModal: View {
	var title: String
	var message: String
	@Binding var showModal: Bool
	
    var body: some View {
		ZStack(alignment: .center) {
			// 배경
			Color.black.opacity(0.15)
				.edgesIgnoringSafeArea(.all)
			
			// 모달
			VStack(spacing: 0) {
				Text(title) // 제목
					.font(.system(size: 16))
					.fontWeight(.medium)
					.padding(.vertical, 16)
				Text(message) // 메시지
					.font(.system(size: 14))
					.fontWeight(.medium)
					.foregroundColor(Color("gray"))
				
				Button { // 확인 버튼
					showModal = false
				} label: {
					Text("확인")
						.font(.system(size: 14))
						.fontWeight(.medium)
						.foregroundColor(.black)
				}
				.padding(.top, 46)
			}
			.frame(maxWidth: .infinity)
			.padding(.horizontal, 40)
			.padding(.vertical, 20)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(.white)
					.shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
					.shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
					.frame(maxWidth: .infinity)
					.padding(.horizontal, 20)
			)
		}
    }
}

struct ConfirmModal_Previews: PreviewProvider {
    static var previews: some View {
		ConfirmModal(title: "안내", message: "안내 메시지입니다.", showModal: .constant(true))
    }
}
