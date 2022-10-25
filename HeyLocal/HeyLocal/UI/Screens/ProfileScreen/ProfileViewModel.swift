//
//  ProfileViewModel.swift
//  HeyLocal
//  프로필 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI
import Combine


extension ProfileScreen {
    class ViewModel: ObservableObject {
        private var userService = UserService()
        
        @Published var author: Author = Author()
        @Published var authorUpdate: AuthorUpdate = AuthorUpdate()
        @Published var travelOns: [TravelOn] = [TravelOn]()
        @Published var opinions: [Opinion] = [Opinion]()
        
        
        // 페이징
        let size = 15
        var travelOnlastItemId: Int?
        var travelOnisEnd = false
        var opinionLastItemId: Int?
        var opinionIsEnd = false
        
        
        var cancellable: AnyCancellable?
        
        /// 사용자 프로필 정보 가져오기
        func getUserProfile(userId: Int) {
            cancellable = userService.loadUserInfo(userId: userId)
                .sink(receiveCompletion: {_ in
                }, receiveValue: { author in
                    self.author = author
                    
                    self.authorUpdate.nickname = self.author.nickname
                    self.authorUpdate.activityRegionId = self.author.activityRegion!.id
                    self.authorUpdate.introduce = self.author.introduce!
                })
        }
        
        /// 작성한 Travel On 목록
        func fetchTravelOns() {
            userService.loadTravelOnsByUser(
                userId: 2,
                lastItemId: Binding(
                    get: { self.travelOnlastItemId },
                    set: { self.travelOnlastItemId = $0 }
                ),
                size: size,
                travelOns: Binding(
                    get: { self.travelOns },
                    set: { self.travelOns = $0 }
                ),
                isEnd: Binding(
                    get: { self.travelOnisEnd },
                    set: { self.travelOnisEnd = $0 }
                )
            )
        }
        
        
        /// 작성한 답변 목록
        func fetchOpinions() {
            userService.loadOpinionsByUser(
                userId: 2,
                lastItemId: Binding(get: { self.opinionLastItemId },
                                    set: { self.opinionLastItemId = $0}),
                size: size,
                opinions: Binding(get: { self.opinions },
                                  set: { self.opinions = $0 }),
                isEnd: Binding(get: { self.opinionIsEnd },
                               set: { self.opinionIsEnd = $0 })
            )
        }
        
        /// 프로필 수정
        func updateUserProfile(userId: Int, userData: AuthorUpdate, profileImage: [UIImage], isDeleted: Bool) {
            userService.updateUserInfo(userId: userId, userData: userData, profileImage: profileImage, isDeleted: isDeleted)
        }
    }
}
