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
    
    func getTravelOns(lastItemId: Int?, pageSize: Int, regionId: Int?, sortBy: String, withOpinions: Bool?) -> AnyPublisher<[TravelOn], Error> {
        return travelOnRepository.getTravelOns(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy, withOpinions: withOpinions)
    }
}
