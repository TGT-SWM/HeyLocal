//
//  DateFormat.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct DateFormat {
	/// yyyy-MM-dd 문자열을 Date로 변환
	static func dateFrom(_ from: String) -> Date {
		let strToDate = DateFormatter()
		strToDate.dateFormat = "yyyy-MM-dd"
		return strToDate.date(from: from)!
	}
	
	/// 날짜 포맷팅
	static func format(_ dateStr: String, _ dateFormat: String) -> String {
		// String -> Date
		let date = dateFrom(dateStr)
		
		// Date -> String
		let dateToStr = DateFormatter()
		dateToStr.dateFormat = dateFormat
		return dateToStr.string(from: date)
	}
}
