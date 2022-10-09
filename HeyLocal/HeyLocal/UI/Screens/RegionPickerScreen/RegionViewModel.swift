//
//  RegionViewModel.swift
//  HeyLocal
//  Region 뷰 모델
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct RegionRepository {
    private let agent = NetworkAgent()
    private let regionUrl = "\(Config.apiURL)/regions"
    
    func getRegions() -> AnyPublisher<[Region], Error> {
        let url = URL(string: regionUrl)!
        var request = URLRequest(url: url)
        
        // HTTP 헤더 구성
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(Config.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Publisher 반환
        return agent.run(request)
    }
}

extension RegionPickerScreen {
    class ViewModel: ObservableObject {
        private var regionRepository = RegionRepository()
        @Published var regions: [Region] = [Region]()
        
        var cancellable: AnyCancellable?
        func fetchRegions() {
            cancellable = regionRepository.getRegions()
                .sink(receiveCompletion: { _ in
                }, receiveValue: { regions in
                    self.regions = regions
                })
        }
    }
}
