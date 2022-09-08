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
    
    func getTravelOnLists(lastItemId: Int?, pageSize: Int, regionId: Int?, sortBy: String, withOpinions: Bool?) -> AnyPublisher<[TravelOn], Error> {
        return travelOnRepository.getTravelOnLists(lastItemId: lastItemId, pageSize: pageSize, regionId: regionId, sortBy: sortBy, withOpinions: withOpinions)
    }
    
    func getTravelOn(travelOnId: Int) -> AnyPublisher<TravelOnDetail, Error> {
        return travelOnRepository.getTravelOn(travelOnId: travelOnId)
    }
}
