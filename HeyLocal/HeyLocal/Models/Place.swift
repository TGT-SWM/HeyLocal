//
//  Place.swift
//  HeyLocal
//	장소 관련 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

// MARK: - Place (장소)

struct Place: Codable, Equatable, Identifiable {
	var id: Int
	var name: String
	var category: String
	var address: String
	var roadAddress: String
	var lat: Double
	var lng: Double
	var link: String
	var itemIndex: Int?
	var arrivalTime: String?
    var region: Region?
    var thumbnailUrl: String?
    
	/// 카테고리의 이름 (ex. 음식점)
	var categoryName: String {
		PlaceCategory.withLabel(category).rawValue
	}
    
	/// Equatable 프로토콜 구현
	/// 장소의 동일 여부는 오직 장소의 ID를 통해 판별합니다.
	static func == (lhs: Place, rhs: Place) -> Bool {
		lhs.id == rhs.id
	}
}

// MARK: - PlaceCategory (장소 카테고리 종류)

enum PlaceCategory: String, CaseIterable {
	case MT1 = "대형마트"
	case CS2 = "편의점"
	case PS3 = "어린이집, 유치원"
	case SC4 = "학교"
	case AC5 = "학원"
	case PK6 = "주차장"
	case OL7 = "주유소, 충전소"
	case SW8 = "지하철역"
	case BK9 = "은행"
	case CT1 = "문화시설"
	case AG2 = "중개업소"
	case PO3 = "공공기관"
	case AT4 = "관광명소"
	case AD5 = "숙박"
	case FD6 = "음식점"
	case CE7 = "카페"
	case HP8 = "병원"
	case PM9 = "약국"
	case ETC = "기타"
	
	/// 열거형의 라벨을 파라미터로 받아 열거형 객체를 반환합니다.
	/// 매칭되는 라벨이 없는 경우에는 PlaceCategory.ETC를 반환합니다.
	static func withLabel(_ label: String) -> PlaceCategory {
		if let placeCategory = self.allCases.first(where: { "\($0)" == label }) {
			return placeCategory
		}
		
		return .ETC // 매칭된 라벨이 없는 경우
	}
}


// MARK: - Distance (장소 사이의 거리 정보)

struct Distance {
	var time: Double = 0 // 분
	var distance: Double = 0 // 미터
}
