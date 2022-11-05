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
	let kakaoAPIService = KakaoAPIService()
	
	var cancellable: AnyCancellable?
    /// 여행On
	func loadTravelOnsByUser(userId: Int, lastItemId: Binding<Int?>, size: Int, travelOns: Binding<[TravelOn]>, isEnd: Binding<Bool>) {
		cancellable = userRepository.getTravelOnsByUser(
			userId: userId,
			lastItemId: lastItemId.wrappedValue,
			size: size
		).sink(
			receiveCompletion: { _ in
				for i in travelOns.indices {
					self.kakaoAPIService.getRegionImage(region: travelOns[i].region)
				}
			},
			receiveValue: {
				travelOns.wrappedValue.append(contentsOf: $0)
				lastItemId.wrappedValue = $0.last?.id
				
				if $0.count < size {
					isEnd.wrappedValue = true
				}
			}
		)
	}
    
    /// 답변
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
    
    /// 사용자 프로필 정보
    func loadUserInfo(userId: Int) -> AnyPublisher<Author, Error> {
        return userRepository.getUser(userId: userId)
    }
    
    func updateUserInfo(userId: Int, userData: AuthorUpdate, profileImage: [UIImage], isDeleted: Bool) {
        return userRepository.updateUserProfile(userId: userId, userData: userData, profileImage: profileImage, isDeleted: isDeleted)
    }
    
    func getUserRanking() -> AnyPublisher<[Author], Error> {
        return userRepository.getUserRanking()
    }
	
	/// 회원 탈퇴를 요청합니다.
	func deleteAccount() {
		guard let id = AuthManager.shared.authorized?.id else { return }
		cancellable = userRepository.deleteAccount(id: id)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					AuthManager.shared.removeAll()
				case .failure(let error):
					print(error)
				}
				
			}, receiveValue: { _ in })
	}
}
