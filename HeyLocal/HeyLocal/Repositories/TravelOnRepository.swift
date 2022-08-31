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
                     numOfViews: 110,
                     numOfComments: 0),
            
            TravelOn(id: 2,
                     title: "여행 On 제목2",
                     region: "인천광역시",
                     uploadDate: Date(),
                     writer: User(name: "나현지",
                                  imageURL: "https://cdna.artstation.com/p/assets/images/images/034/457/374/large/shin-min-jeong-.jpg?1612345113"),
                     numOfViews: 10,
                     numOfComments: 40),
            
            TravelOn(id: 3,
                     title: "여행 On 제목2",
                     region: "인천광역시",
                     uploadDate: Date(),
                     writer: User(name: "나현지",
                                  imageURL: "https://cdna.artstation.com/p/assets/images/images/034/457/374/large/shin-min-jeong-.jpg?1612345113"),
                     numOfViews: 30,
                     numOfComments: 100)
        ]
        
        return mockingData
    }
}
