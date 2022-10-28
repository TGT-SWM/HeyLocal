//
//  AuthTextField.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct AuthTextField: View {
	var name: String = ""
	@Binding var value: String
	var placeholder = ""
	var secured = false
	
    var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			if !name.isEmpty {
				Text(name)
					.font(.system(size: 14))
					.fontWeight(.medium)
			}
			
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), lineWidth: 1)
					.background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
				
				if secured {
					SecureField(placeholder, text: $value)
						.font(.system(size: 12))
						.padding(.horizontal, 12)
				} else {
					TextField(placeholder, text: $value)
						.font(.system(size: 12))
						.padding(.horizontal, 12)
				}
			}
			.frame(height: 44)
		}
    }
}

struct AuthTextField_Previews: PreviewProvider {
    static var previews: some View {
		AuthTextField(
			name: "비밀번호",
			value: .constant(""), placeholder: "비밀번호", secured: true)
    }
}
