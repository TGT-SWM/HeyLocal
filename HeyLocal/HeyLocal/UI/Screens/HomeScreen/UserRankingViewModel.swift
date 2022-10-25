//
//  UserRankingViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import AVFAudio

extension UserRankingScreen {
    class ViewModel: ObservableObject {
        private var userService = UserService()
        @Published var users: [Author]
        
        var cancellable: AnyCancellable?
        init() {
            self.users = [Author()]
        }
        
        // 사용자 랭킹
        func getUserRanking() {
            cancellable = userService.getUserRanking()
                .sink(receiveCompletion: { _ in
                }, receiveValue: { users in
                    self.users = users
                })
        }
    }
}
