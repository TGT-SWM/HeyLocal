//
//  TravelOnViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension TravelOnList {
    class ViewModel: ObservableObject {
        private var travelOnService = TravelOnService()
        @Published var travelOns = [TravelOn]()
        
        var cancellable: AnyCancellable?
        init() {
            cancellable = travelOnService.getTravelOns(lastItemId: nil, pageSize: 3, regionId: nil, sortBy: "DATE", withOpinions: nil)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { travelOns in
                    self.travelOns = travelOns
                })
        }
        
        func fetchTravelOn(lastItemId: Int?, pageSize: Int, regionId: Int?, sortBy: String, withOpinions: Bool, withNonOpinions: Bool) {
            
            // withOpinions 값
            var with_opinons: Bool? = nil
            if (withOpinions != withNonOpinions) {
                with_opinons = withOpinions
            }
            
            cancellable = travelOnService.getTravelOns(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy, withOpinions: with_opinons)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { travelOns in
                    self.travelOns = travelOns
                })
        }
    }
}
