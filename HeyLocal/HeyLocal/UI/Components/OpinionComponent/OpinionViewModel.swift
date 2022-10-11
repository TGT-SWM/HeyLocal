//
//  OpinionViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension OpinionComponent {
    class ViewModel: ObservableObject {
        private var opinionService = OpinionService()
        @Published var opinions: [Opinion]
        @Published var opinion: Opinion
        
        var cancellable: AnyCancellable?
        init() {
            self.opinions = [Opinion()]
            self.opinion = Opinion()
        }
        
        // 답변 목록조회
        func fetchOpinions(travelOnId: Int, opinionId: Int?) {
            cancellable = opinionService.getOpinions(travelOnId: travelOnId)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { opinions in
                    self.opinions = opinions
                    
                    // 답변 상세조회
                    if opinionId != nil {
                        for i in 0 ..< self.opinions.count {
                            if self.opinions[i].id == opinionId {
                                self.opinion = self.opinions[i]
                                print("\(self.opinion.description)")
                                break
                            }
                        }
                    }
                })
        }
    }
}
