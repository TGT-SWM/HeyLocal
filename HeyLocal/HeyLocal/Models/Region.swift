//
//  Region.swift
//  HeyLocal
//  지역 관련 모델 
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct Region: Codable, Identifiable, Hashable {
    var id: Int = 0
    var city: String? = nil
    var state: String = ""
    
    var thumbnailUrl: String? = nil
//    {
//        var tmp = ""
//        KakaoAPIService().getImageUrl(query: self.state, completionHandler: { data, response, error in
//            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            if httpResponse.statusCode == 200 {
//                do {
//                    let results =  try JSONDecoder().decode(KakaoImageResponse.self, from: data)
//                    tmp = results.documents.map(\.image_url)[0]
//                } catch {
//                    print("error")
//                }
//            }
//        })
//        print("tttttmpt", tmp)
//        return tmp
//    }
}
