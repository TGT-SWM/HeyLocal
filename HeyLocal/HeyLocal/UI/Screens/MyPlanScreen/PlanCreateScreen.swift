//
//  PlanCreateScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlanCreateScreen (플랜 생성 화면)

struct PlanCreateScreen: View {
	@ObservedObject var viewModel = ViewModel()
	
    var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(viewModel.travelOns, id: \.id) {
					TravelOnComponent(travelOn: $0)
				}
				
				if !viewModel.isEnd {
					ProgressView()
						.onAppear {
							viewModel.fetchTravelOns()
						}
				}
			}
			
		}
		.navigationTitle("여행 On 선택")
		.navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Previews

struct PlanCreateScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlanCreateScreen()
    }
}
