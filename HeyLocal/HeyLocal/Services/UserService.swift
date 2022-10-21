//
//  UserService.swift
//  HeyLocal
//	사용자 서비스
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class UserService {
	let userRepository = UserRepository()
	
	var cancellable: AnyCancellable?
    // 여행On
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
    
    // 답변
    func loadOpinionsByUser(userId: Int, lastItemId: Binding<Int?>, size: Int, opinions: Binding<[Opinion]>, isEnd: Binding<Bool>) {
        cancellable = userRepository.getOpinionsByUser(
            userId: userId,
            lastItemId: lastItemId.wrappedValue,
            size: size
        ).sink(
            receiveCompletion: { _ in },
            receiveValue: {
                opinions.wrappedValue.append(contentsOf: $0)
                lastItemId.wrappedValue = $0.last?.id
                
                if $0.isEmpty {
                    isEnd.wrappedValue = true
                }
            }
        )
    }
    
    // 사용자 프로필 정보
    func loadUserInfo(userId: Int) -> AnyPublisher<Author, Error> {
        return userRepository.getUser(userId: userId)
    }
    
}
