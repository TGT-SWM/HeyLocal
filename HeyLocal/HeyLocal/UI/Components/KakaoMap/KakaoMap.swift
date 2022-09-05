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
		let view = MTMapView(frame: .zero)
		view.currentLocationTrackingMode = .onWithoutHeading
		view.showCurrentLocationMarker = true
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
}
