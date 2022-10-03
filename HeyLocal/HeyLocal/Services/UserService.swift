//
//  UserService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class UserService {
	let userRepository = UserRepository()
	
	var cancellable: AnyCancellable?
	
	func loadTravelOnsByUser(userId: Int, lastItemId: Binding<Int?>, size: Int, travelOns: Binding<[TravelOn]>, isEnd: Binding<Bool>) {
		cancellable = userRepository.getTravelOnsByUser(
			userId: userId,
			lastItemId: lastItemId.wrappedValue,
			size: size
		).sink(
			receiveCompletion: { _ in },
			receiveValue: {
				travelOns.wrappedValue.append(contentsOf: $0)
				lastItemId.wrappedValue = $0.last?.id
				
				if $0.isEmpty {
					isEnd.wrappedValue = true
				}
			}
		)
	}
}
