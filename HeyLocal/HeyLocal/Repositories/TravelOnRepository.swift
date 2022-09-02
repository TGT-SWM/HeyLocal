//
//  TravelOnRepository.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation

struct TravelOnRepository {
    func load() -> [TravelOn] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년MM월dd일"
        let date1 = formatter.date(from: "2022년08월24일")!
        let date2 = formatter.date(from: "2022년08월26일")!
        let date3 = formatter.date(from: "2022년07월17일")!
        
        
        let mockingData = [
            TravelOn(id: 1,
                     title: "여행 On 제목1",
                     region: "부산광역시",
                     uploadDate: date1,
                     writer: User(user_id: "kimhyeonji",
                                  name: "김현지",
                                  imageURL: "https://cdna.artstation.com/p/assets/images/images/034/457/380/large/shin-min-jeong-.jpg?1612345128"),
                     numOfViews: 110,
                     numOfComments: 0),
            
            TravelOn(id: 2,
                     title: "여행 On 제목2",
                     region: "인천광역시",
                     uploadDate: date2,
                     writer: User(user_id: "nahyeonji",
                                  name: "나현지",
                                  imageURL: "https://cdna.artstation.com/p/assets/images/images/034/457/374/large/shin-min-jeong-.jpg?1612345113"),
                     numOfViews: 10,
                     numOfComments: 40),
            
            TravelOn(id: 3,
                     title: "여행 On 제목3",
                     region: "인천광역시",
                     uploadDate: date3,
                     writer: User(user_id: "nahyeonji",
                                  name: "나현지",
                                  imageURL: "https://cdna.artstation.com/p/assets/images/images/034/457/374/large/shin-min-jeong-.jpg?1612345113"),
                     numOfViews: 30,
                     numOfComments: 100)
        ]
        
        return mockingData
    }
}
