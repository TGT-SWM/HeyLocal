//
//  TravelOnService.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct TravelOnService {
    private var travelOnRepository = TravelOnRepository()
    
    func load() -> [TravelOn] {
        return travelOnRepository.load()
    }
}
