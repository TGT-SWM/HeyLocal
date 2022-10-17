//
//  OpinionViewModel.swift
//  HeyLocal
//  답변 뷰 모델
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
        
        // 답변 삭제
        func deleteOpinion(travelOnId: Int, opinionId: Int){
            return opinionService.deleteOpinion(travelOnId: travelOnId, opinionId: opinionId)
        }
        
        // 답변 등록
        func postOpinion(travelOnId: Int, opinionData: Opinion) -> Int {
            return opinionService.postOpinion(travelOnId: travelOnId, opinionData: opinionData)
        }
        
        // 답변 수정
        func updateOpinion(travelOnId: Int, opinionId: Int, opinionData: Opinion) {
            return opinionService.updateOpinion(travelOnId: travelOnId, opinionId: opinionId, opinionData: opinionData)
        }
    }
}
