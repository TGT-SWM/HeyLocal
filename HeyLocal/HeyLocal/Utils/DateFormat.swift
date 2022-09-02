//
//  DateFormat.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct DateFormat {
	/// 날짜 포맷팅 (yyyy-MM-dd -> M월 d일)
	static func format(_ dateStr: String) -> String {
		// String -> Date
		let strToDate = DateFormatter()
		strToDate.dateFormat = "yyyy-MM-dd"
		let date = strToDate.date(from: dateStr)!
		
		// Date -> String
		let dateToStr = DateFormatter()
		dateToStr.dateFormat = "M월 d일"
		return dateToStr.string(from: date)
	}
}
