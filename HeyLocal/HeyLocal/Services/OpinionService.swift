//
//  OpinionService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct OpinionService {
    private var opinionRepository = OpinionRepository()
    
    // 답변 목록조회
    func getOpinions(travelOnId: Int) -> AnyPublisher<[Opinion], Error> {
        return opinionRepository.getOpinions(travelOnId: travelOnId)
    }
    
    // 답변 삭제
    func deleteOpinion(travelOnId: Int, opinionId: Int) {
        return opinionRepository.deleteOpinion(travelOnId: travelOnId, opinionId: opinionId)
    }
}
