//
//  PlaceService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct PlaceService {
    private var placeRepository = PlaceRepository()
    
    // Hot한 장소
    func getHotPlaces() -> AnyPublisher<[Place], Error> {
        return placeRepository.getHotPlaces()
    }
    
    
}
