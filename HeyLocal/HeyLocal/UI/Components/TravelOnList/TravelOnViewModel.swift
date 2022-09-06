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
        @Published final var travelOns = [TravelOn]()
        
        var cancellable: AnyCancellable?
        
        init() {
            fetchTravelOns()
        }
        
        func fetchTravelOn() {
            cancellable = travelOnService.getTravelOns()
                .sink(receiveCompletion: { _ in
                }, receiveValue: { travelOns in
                    self.travelOns = travelOns
                })
        }
        
        func jungin(user_id: String, showCommentOnly: Bool, showNonCommentOnly: Bool, sortedType: Int) -> [TravelOn]
        {
            var userTravelOn: [TravelOn] {
                var resultTravelOns: [TravelOn] = travelOns
        
                if user_id != "" {
                    resultTravelOns = travelOns.filter { travelon in
                        (travelon.writer.user_id == user_id)
                    }
                }
                return resultTravelOns
            }
        
            // TravleOn 필터링
            var filteredTravelOns: [TravelOn] {
                var resultTravelOns: [TravelOn] = travelOns
        
                resultTravelOns = userTravelOn
                // 답변 있는 것만 보기
                if showCommentOnly {
                    resultTravelOns = userTravelOn.filter { travelon in
                        (travelon.numOfComments > 0)
                    }
        
        //            resultTravelOns = viewModel.showOnlyComments()
                }
        
                // 답변 없는 것만 보기
                else if showNonCommentOnly {
                    resultTravelOns = userTravelOn.filter { travelon in
                        (travelon.numOfComments == 0)
                    }
        
        //            resultTravelOns = viewModel.showOnlyNonComments()
                }
                return resultTravelOns
            }
        
            // TravelOn 정렬
            var sortedTravelOns: [TravelOn] {
                var resultTravelOns: [TravelOn] = travelOns
        
                // 최신순
                if sortedType == 0 {
                    resultTravelOns = filteredTravelOns.sorted(by: {$0.uploadDate > $1.uploadDate})
        //            viewModel.fetchTravelOns()
        //            resultTravelOns = viewModel.travelOns
        
        //            resultTravelOns = viewModel.travelOns
                }
        
                // 조회순
                else if sortedType == 1 {
                    resultTravelOns = filteredTravelOns.sorted(by: {$0.numOfViews > $1.numOfViews})
        //            viewModel.orderedByViews()
        //            resultTravelOns = viewModel.travelOns
        
        //            resultTravelOns = viewModel.orderedByViews()
                }
        
                // 답변 많은 순
                else {
                    resultTravelOns = filteredTravelOns.sorted(by: {$0.numOfComments > $1.numOfComments})
        //            viewModel.orderedByComments()
        //            resultTravelOns = viewModel.travelOns
                }
                return resultTravelOns
            }
            
            return sortedTravelOns
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
