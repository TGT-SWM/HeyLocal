//
//  LocationService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
	let manager = CLLocationManager()
	var completionHandler: ((CLLocationCoordinate2D) -> (Void))?
	
	override init() {
		super.init()
		
		manager.delegate = self // CLLocationManager의 delegate 설정
//		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.requestWhenInUseAuthorization() // 위치 정보 승인 요청
	}
	
	/// 위치 정보를 요청합니다.
	func requestLocation(completion: @escaping ((CLLocationCoordinate2D) -> (Void))) {
		completionHandler = completion
		manager.requestLocation()
		
	}
	
	/// 위치 정보 업데이트를 중단합니다.
	func stopUpdatingLocation() {
		manager.stopUpdatingHeading()
	}
	
	/// 위치 정보가 업데이트 될 때 호출되는 delegate 함수입니다.
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else {
			return
		}
		
		// requestLocation 에서 등록한 completion handler를 통해 위치 정보를 전달
		if let completion = self.completionHandler {
			completion(location.coordinate)
		}
		
		// 위치 정보 업데이트 중단
		manager.stopUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}
