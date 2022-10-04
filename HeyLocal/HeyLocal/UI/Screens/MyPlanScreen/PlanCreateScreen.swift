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
	@Environment(\.presentationMode) var presentationMode
	
    var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(viewModel.travelOns, id: \.id) { travelOn in
					TravelOnComponent(travelOn: travelOn)
						.onTapGesture {
							viewModel.pickTravelOn(travelOn)
						}
						.if(travelOn.id == viewModel.selected?.id) { view in
							view.background(Color("lightGray"))
						}
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
		.toolbar {
			if viewModel.selected != nil {
				Button("확인") {
					viewModel.submit {
						presentationMode.wrappedValue.dismiss()
					} onError: { error in
						print(error)
//						let apiError: APIError = error as! APIError
//						print(apiError.description)
					}
				}
			}
		}
    }
}


// MARK: - Previews

struct PlanCreateScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlanCreateScreen()
    }
}
