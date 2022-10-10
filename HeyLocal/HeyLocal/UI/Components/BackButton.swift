//
//  BackButton.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - 뒤로 가기 버튼

struct BackButton: View {
	@Environment(\.dismiss) var dismiss
	
	var action: (() -> Void)?
	
    var body: some View {
		Button {
			if let action = action { action() }
			dismiss()
		} label: {
			Image(systemName: "chevron.left")
				.foregroundColor(.black)
		}
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
