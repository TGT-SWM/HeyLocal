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
            
            // 조회수 정렬
//            travelOns = travelOns.sorted(by: {$0.numOfViews > $1.numOfViews})
//            
//            // 답변수 정렬
//            travelOns = travelOns.sorted(by: {$0.numOfComments > $1.numOfComments})

            // 답변 있는 것만
//            travelOns = travelOns.filter({$0.numOfComments > 0})
            
            // 답변 없는 것만
//            travelOns = travelOns.filter({$0.numOfComments == 0})
        }
    }
}
