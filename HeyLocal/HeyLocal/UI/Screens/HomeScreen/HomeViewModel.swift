//
//  HomeViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine
import SwiftUI

extension HomeScreen {
    class ViewModel: ObservableObject {
        private var userService = UserService()
        private var placeService = PlaceService()
        private var travelOnService = TravelOnService()
        private var kakaoService = KakaoAPIService()
        
        @Published var users: [Author]
        @Published var rankings: [Author]
        @Published var hotplaces: [Place]
        @Published var travelOns: [TravelOn]
        
        var cancellable: AnyCancellable?
        init() {
            self.users = [Author]()
            self.rankings = [Author]()
            self.hotplaces = [Place]()
            self.travelOns = [TravelOn]()
        }
        
        // 사용자 랭킹
        func getUserRanking() {
            cancellable = userService.getUserRanking()
                .sink(receiveCompletion: { _ in
                }, receiveValue: { users in
                    self.users = users
                    
                    self.rankings.removeAll()
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
                    
                    for i in 0..<self.hotplaces.count {
                        self.kakaoService.getPlaceImage(place: Binding(get: { self.hotplaces[i] },
                                                                       set: { self.hotplaces[i] = $0 }))
                        
                        if self.hotplaces[i].thumbnailUrl != nil {
                            print("Hot Place Thumbnail Image !!", self.hotplaces[i].thumbnailUrl! )
                        }
                    }
                })
        }
        
        
        
        // 여행On 
        func getRecentTravelOns() {
            
            cancellable = travelOnService.getTravelOnLists(lastItemId: nil, pageSize: 5, keyword: nil, regionId: nil, sortBy: "DATE", withOpinions: nil)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { travelOns in
                    self.travelOns = travelOns
                    
                    for i in 0..<self.travelOns.count {
                        self.kakaoService.getRegionImage(region: Binding(get: { self.travelOns[i].region },
                                                                         set: { self.travelOns[i].region = $0 }))
                    }
                })
        }
    }
}
