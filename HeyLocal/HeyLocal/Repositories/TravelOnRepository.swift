//
//  TravelOnRepository.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct TravelOnRepository {
    func load() -> [TravelOn] {
        let mockingData = [
            TravelOn(id: 1,
                     title: "여행 On 제목1",
                     region: "부산광역시",
                     uploadDate: Date(),
                     writer: User(name: "김현지",
                                  imageURL: "https://cdna.artstation.com/p/assets/images/images/034/457/380/large/shin-min-jeong-.jpg?1612345128"),
                     numOfViews: 0,
                     numOfComments: 0)
        ]
        
        return mockingData
    }
}
