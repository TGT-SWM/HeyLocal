//
//  ProfileViewModel.swift
//  HeyLocal
//  프로필 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension ProfileScreen {
    class ViewModel: ObservableObject {
        private var userService = UserService()
        @Published var travelOns: [TravelOn]
        @Published var opinions: [Opinion]
        
        var cancellable: AnyCancellable?
        init() {
            self.travelOns = [TravelOn]()
            self.opinions = [Opinion]()
        }
        
        
        // 작성한 Travel On 목록
        func fetchTravelOns() {
            
        }
        
        
        // 작성한 답변 목록
        func fetchOpinions() {
            
        }
    }
}
