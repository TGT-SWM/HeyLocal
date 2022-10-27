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
    
    // 지역 전체목록 조회
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
    
    // 특정 지역 조회(id)
    func getRegion(regionId: Int) -> AnyPublisher<[Region], Error> {
        let urlString = "\(regionUrl)?regionId=\(regionId)"
        let url = URL(string: urlString)!
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

extension RegionPickerScreen {
    class ViewModel: ObservableObject {
        private var regionRepository = RegionRepository()
        @Published var regions: [Region] = [Region]()
        @Published var region: Region = Region()
        @Published var regionName: String = "지역별"
        
        var cancellable: AnyCancellable?
        
        // 지역 전체목록 조회
        func fetchRegions() {
            cancellable = regionRepository.getRegions()
                .sink(receiveCompletion: { _ in
                }, receiveValue: { regions in
                    self.regions = regions
                })
        }
        
        // 특정 지역 조회(id)
        func getRegion(regionId: Int) {
            cancellable = regionRepository.getRegion(regionId: regionId)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { region in
                    self.region = region[0]
                    self.regionName = regionNameFormatter(region: region[0])
                })
        }
    }
}
