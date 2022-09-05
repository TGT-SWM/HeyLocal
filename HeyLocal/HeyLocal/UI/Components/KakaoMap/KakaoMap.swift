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
		addMarkers(view)
		
		// 지도 센터와 줌 레벨 설정
		setMapCenter(view)
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
	
	/// 지도에 마커를 추가합니다.
	func addMarkers(_ mapView: MTMapView) {
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
	
	/// 장소들을 모두 보여줄 수 있는 센터와 줌 레벨 값을 반환합니다.
	func setMapCenter(_ mapView: MTMapView) {
		let coords: [(Double, Double)] = places.map({ ($0.lat, $0.lng )})
		
		// 평균값 계산
		var sumOfLats: Double = 0
		var sumOfLngs: Double = 0
		for (lat, lng) in coords {
			sumOfLats += lat
			sumOfLngs += lng
		}
		
		let centerLat = sumOfLats / Double(coords.count)
		let centerLng = sumOfLngs / Double(coords.count)
		
		// 줌 레벨
		let zoomLevel: MTMapZoomLevel = 3
		
		// 적용
		mapView.setMapCenter(
			MTMapPoint(geoCoord: MTMapPointGeo(latitude: centerLat, longitude: centerLng)),
			zoomLevel: zoomLevel,
			animated: true
		)
	}
}
