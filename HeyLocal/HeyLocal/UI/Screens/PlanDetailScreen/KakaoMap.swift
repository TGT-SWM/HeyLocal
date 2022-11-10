//
//  KakaoMap.swift
//  HeyLocal
//	카카오맵 지도 뷰
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import UIKit

struct KakaoMap: UIViewRepresentable {
	@Binding var places: [Place]
	var showCurrentLocation = false
	
	func makeUIView(context: Context) -> MTMapView {
		// 참고 : http://susemi99.kr/6131/
		// TODO: 다른 화면으로 이동해도 메모리 해제가 이루어지지 않을 수 있음. 해당 문제 확인하여 수정 필요.
		let view = MTMapView(frame: .zero)
		
		// 현재 위치 마커
		if showCurrentLocation {
			view.currentLocationTrackingMode = .onWithoutHeading
			view.showCurrentLocationMarker = true
		} else {
			view.currentLocationTrackingMode = .off
			view.showCurrentLocationMarker = false
		}
		
		// 마커 추가
		addMarkers(view)
		
		// 라인 추가
		addLines(view)
		
		// 지도 센터와 줌 레벨 설정
		if !showCurrentLocation {
			setMapCenter(view)
		}
		
		return view
	}
	
	func updateUIView(_ view: MTMapView, context: Context) {
		// 마커 초기화
		view.removeAllPOIItems()
		
		// 마커 추가
		addMarkers(view)
		
		// 라인 추가
		addLines(view)
		
		// 지도 센터와 줌 레벨 설정
		if !showCurrentLocation {
			setMapCenter(view)
		}
	}
	
	/// 지도에 마커를 추가합니다.
	func addMarkers(_ mapView: MTMapView) {
		for idx in places.indices {
			let place = places[idx]
			let marker = MTMapPOIItem()
			
			// 좌표
			let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: place.lat, longitude: place.lng))
			marker.mapPoint = mapPoint
			
			// 마커 이미지
			var markerImage = "marker-etc"
			if markerImages.indices.contains(idx) {
				markerImage = markerImages[idx]
			}
			
			// 기타 설정
			marker.markerType = .customImage
			marker.customImageName = markerImage
			marker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 24, offsetY: 24)
			marker.itemName = "\(idx + 1). \(place.name)"
			marker.tag = idx
			
			mapView.add(marker)
		}
	}
	
	/// 지도에 라인을 추가합니다.
	func addLines(_ mapView: MTMapView) {
		// Polyline 객체 생성
		let polyline = MTMapPolyline.polyLine()!
		polyline.polylineColor = .purple
		
		// 좌표 찍기
		var mapPoints: [MTMapPoint] = []
		for place in places {
			let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: place.lat, longitude: place.lng))!
			mapPoints.append(mapPoint)
		}
		polyline.addPoints(mapPoints)
		
		mapView.addPolyline(polyline)
	}
	
	/// 장소들을 모두 보여줄 수 있는 센터와 줌 레벨 값을 반환합니다.
	func setMapCenter(_ mapView: MTMapView) {
		// 장소가 있을 때만 동작해야 함
		if places.isEmpty {
			return
		}
		
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
	
	/// 마커 이미지 에셋의 배열입니다.
	let markerImages = [
		"marker-1",
		"marker-2",
		"marker-3",
		"marker-4",
		"marker-5",
		"marker-6",
		"marker-7",
		"marker-8",
		"marker-9"
	]
}
