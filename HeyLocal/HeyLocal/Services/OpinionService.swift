//
//  OpinionService.swift
//  HeyLocal
//  답변 서비스
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
    
    // 답변 등록
    func postOpinion(travelOnId: Int, opinionData: Opinion, generalImages: [SelectedImage], foodImages: [SelectedImage], cafeImages: [SelectedImage], photoSpotImages: [SelectedImage]) -> Int {
        return opinionRepository.postOpinion(travelOnId: travelOnId, opinionData: opinionData, generalImages: generalImages, foodImages: foodImages, cafeImages: cafeImages, photoSpotImages: photoSpotImages)
    }
    
    // 답변 수정
    func updateOpinion(travelOnId: Int, opinionId: Int, opinionData: Opinion,
                       generalImages: [SelectedImage], foodImages: [SelectedImage], cafeImages: [SelectedImage], photoSpotImages: [SelectedImage],
                       deleteImages: [String], deleteFoodImages: [String], deleteCafeImages: [String], deletePhotoSpotImages: [String]) {
        return opinionRepository.updateOpinion(travelOnId: travelOnId, opinionId: opinionId, opinionData: opinionData,
                                               generalImages: generalImages, foodImages: foodImages, cafeImages: cafeImages, photoSpotImages: photoSpotImages, deleteImages: deleteImages, deleteFoodImages: deleteFoodImages, deleteCafeImages: deleteCafeImages, deletePhotoSpotImages: deletePhotoSpotImages)
    }
}
