//
//  RegionPickerViewModel.swift
//  HeyLocal
//  지역 선택 Picker 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct RegionRepository {
    private let agent = NetworkAgent()
    private let regionUrl = "\(Config.apiURL)/regions"
    
//    @Published var 
    
    
    func getRegions() -> AnyPublisher<[Region], Error> {
        let url = URL(string: regionUrl)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(AuthManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Publisher 반환
        return agent.run(request)
    }
}

extension RegionPicker {
    class ViewModel: ObservableObject {
        private var regionRepository = RegionRepository()
        @Published var regionList: [Region] = [Region]()
        
        var cancellable: AnyCancellable?
        func fetchRegions() {
            
        }
        
    }
}
