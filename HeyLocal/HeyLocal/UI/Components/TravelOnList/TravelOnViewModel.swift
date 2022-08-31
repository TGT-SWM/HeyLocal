//
//  TravelOnViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

extension TravelOnList {
    class ViewModel: ObservableObject {
        private var travelOnService = TravelOnService()
        @Published final var travelOns = [TravelOn]()
        
        init() {
            fetchTravelOns()
        }
        
        func fetchTravelOns() {
            travelOns = travelOnService.load()
        }
    }
}
