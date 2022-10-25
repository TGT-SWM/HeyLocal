//
//  HomeViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension HomeScreen {
    class ViewModel: ObservableObject {
        private var userService = UserService()
        private var placeService = PlaceService()
        
        @Published var users: [Author]
        @Published var rankings: [Author]
        @Published var hotplaces: [Place]
        
        var cancellable: AnyCancellable?
        init() {
            self.users = [Author]()
            self.rankings = [Author]()
            self.hotplaces = [Place]()
        }
        
        // 사용자 랭킹
        func getUserRanking() {
            cancellable = userService.getUserRanking()
                .sink(receiveCompletion: { _ in
                }, receiveValue: { users in
                    self.users = users
                    
                    self.rankings.append(self.users[0])
                    self.rankings.append(self.users[1])
                    self.rankings.append(self.users[2])
                })
        }
        
        // Hot한 장소
        func getHotPlaces() {
            cancellable = placeService.getHotPlaces()
                .sink(receiveCompletion: { _ in
                }, receiveValue: { places in
                    self.hotplaces = places
                })
        }
    }
}
