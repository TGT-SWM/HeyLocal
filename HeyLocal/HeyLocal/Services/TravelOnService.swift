//
//  TravelOnService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct TravelOnService {
    private var travelOnRepository = TravelOnRepository()
    
    func load() -> [TravelOn] {
        return travelOnRepository.load()
    }
    
    func getTravelOns() -> AnyPublisher<[TravelOn], Error> {
        return travelOnRepository.getTravelOns()
    }
}
