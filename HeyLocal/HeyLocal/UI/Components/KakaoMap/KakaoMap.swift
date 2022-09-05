//
//  KakaoMap.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import UIKit

struct KakaoMap: UIViewRepresentable {
	var places: [Place]
	
	func makeUIView(context: Context) -> some UIView {
		// 참고 : http://susemi99.kr/6131/
		// TODO: 다른 화면으로 이동해도 메모리 해제가 이루어지지 않을 수 있음. 해당 문제 확인하여 수정 필요.
		let view = MTMapView(frame: .zero)
		view.currentLocationTrackingMode = .off
		view.showCurrentLocationMarker = true
		
		// 마커 추가
		addMarkers(mapView: view)
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
	
	func addMarkers(mapView: MTMapView) {
		for idx in places.indices {
			let place = places[idx]
			let marker = MTMapPOIItem()
			
			// 좌표
			let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: place.lat, longitude: place.lng))
			marker.mapPoint = mapPoint
			
			// 기타 설정
			marker.markerType = .redPin
			marker.itemName = place.name
			marker.tag = idx
			
			mapView.add(marker)
		}
	}
}
