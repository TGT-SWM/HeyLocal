//
//  OpinionViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

extension OpinionComponent {
    class ViewModel: ObservableObject {
        private var opinionService = OpinionService()
        @Published var opinions: [Opinion]
        
        var cancellable: AnyCancellable?
        init() {
            self.opinions = [Opinion()]
        }
        
        func fetchOpinions(travelOnId: Int) {
            cancellable = opinionService.getOpinions(travelOnId: travelOnId)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { opinions in
                    print("LOOK AT :::::::::::::: \(travelOnId)")
                    self.opinions = opinions
                })
        }
        
    }
}
