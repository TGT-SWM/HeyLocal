//
//  ObservableObject+Extensions.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI

extension ObservableObject {
	/// 해당 KeyPath에 대한 Binding 객체를 반환합니다.
	func bind<Value>(_ keyPath: WritableKeyPath<Self, Value>) -> Binding<Value> {
		let defaultValue = self[keyPath: keyPath]
		return Binding(
			get: { [weak self] in
				self?[keyPath: keyPath] ?? defaultValue
			},
			set: { [weak self] in
				self?[keyPath: keyPath] = $0
			}
		)
	}
}
