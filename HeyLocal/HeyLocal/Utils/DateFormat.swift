//
//  DateFormat.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct DateFormat {
	/// String을 Date로 변환
	static func strToDate(_ from: String, _ dateFormat: String) -> Date {
		let toDate = DateFormatter()
		toDate.dateFormat = dateFormat
		return toDate.date(from: from)!
	}
	
	// Date를 String으로 변환
	static func dateToStr(_ from: Date, _ dateFormat: String) -> String {
		let toStr = DateFormatter()
		toStr.dateFormat = dateFormat
		return toStr.string(from: from)
	}
	
	/// 날짜 문자열 포맷팅
	static func format(_ dateStr: String, from: String, to: String) -> String {
		return dateToStr(strToDate(dateStr, from), to)
	}
}
