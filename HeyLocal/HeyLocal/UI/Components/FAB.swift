//
//  FAB.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - FAB (Floating Action Button)

struct FAB: View {
	/// 버튼 클릭 시 호출되는 클로저입니다.
	var action: () -> Void
	
    var body: some View {
		Button(action: action) { label }
    }
	
	var label: some View {
		ZStack {
			Circle()
				.frame(width: 50, height: 50)
				.foregroundColor(Color("orange"))
				.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 2, x: 0, y: 1)
				.shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.10), radius: 6, x: 0, y: 2)
			Image(systemName: "plus")
				.foregroundColor(.white)
		}
	}
}


// MARK: - Previews

struct FAB_Previews: PreviewProvider {
    static var previews: some View {
		FAB(action: {})
    }
}
