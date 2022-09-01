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
        
        // 기본 최신순으로 Data fetch
        func fetchTravelOns() {
            travelOns = travelOnService.load()
            travelOns = travelOns.sorted(by: { $0.uploadDate > $1.uploadDate })
        }
        
        // 조회순 정렬
        func orderedByViews() -> [TravelOn] {
            travelOns = travelOns.sorted(by: { $0.numOfViews > $1.numOfViews })
            return travelOns
        }
        
        // 답변순 정렬
        func orderedByComments() -> [TravelOn] {
            travelOns = travelOns.sorted(by: { $0.numOfComments > $1.numOfComments })
            return travelOns
        }
        
        // 답변 있는 것만 보기
        func showOnlyComments() -> [TravelOn] {
            travelOns = travelOns.filter { travelon in
                (travelon.numOfComments > 0)
            }
            
            return travelOns
        }
        
        // 답변 없는 것만 보기
        func showOnlyNonComments() -> [TravelOn] {
            travelOns = travelOns.filter { travelon in
                (travelon.numOfComments == 0)
            }
            
            return travelOns
        }
    }
}
