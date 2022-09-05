//
//  KakaoMap.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import UIKit

struct KakaoMap: UIViewRepresentable {
	func makeUIView(context: Context) -> some UIView {
		// 참고 : http://susemi99.kr/6131/
		// TODO: 다른 화면으로 이동해도 메모리 해제가 이루어지지 않을 수 있음. 해당 문제 확인하여 수정 필요.
		let view = MTMapView(frame: .zero)
		view.currentLocationTrackingMode = .onWithoutHeading
		view.showCurrentLocationMarker = true
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
}
