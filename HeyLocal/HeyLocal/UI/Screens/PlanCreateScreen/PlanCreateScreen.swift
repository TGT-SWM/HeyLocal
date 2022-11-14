//
//  PlanCreateScreen.swift
//  HeyLocal
//	플랜 생성 화면 (여행 On 선택)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlanCreateScreen (플랜 생성 화면)

struct PlanCreateScreen: View {
	@ObservedObject var viewModel = ViewModel()
	@Environment(\.presentationMode) var presentationMode
	
    var body: some View {
		ScrollView { travelOnList }
			.navigationTitle("여행 On 선택")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarBackButtonHidden(true)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					BackButton()
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					if viewModel.selected != nil { // 선택한 항목이 있으면 확인 버튼을 표시합니다.
						confirmButton
					}
				}
			}
			.alert(isPresented: $viewModel.showAlert) {
				alertModal // 에러 발생 시 Alert 메시지 출력
			}
    }
}


// MARK: - travelOnList (여행 On 리스트)

extension PlanCreateScreen {
	/// 여행 On 리스트 뷰입니다.
	var travelOnList: some View {
		LazyVStack {
			ForEach(viewModel.travelOns, id: \.id) { listItem($0) }
			
			// 여행 On이 없는 경우
			if viewModel.travelOns.isEmpty && viewModel.isEnd {
				emptyView
			}
			
			// 더 이상 로드할 컨텐츠가 없는 경우 표시하지 않습니다.
			if !viewModel.isEnd {
				ProgressView()
					.onAppear {
						viewModel.fetchTravelOns()
					}
			}
		}
	}
	
	/// 여행 On 리스트의 항목입니다.
	func listItem(_ travelOn: TravelOn) -> some View {
		TravelOnComponent(travelOn: travelOn)
			.onTapGesture {
				viewModel.pickTravelOn(travelOn)
			}
			.if(travelOn.id == viewModel.selected?.id) { view in
				view.background(Color("lightGray"))
			}
	}
	
	/// 여행 On이 없는 경우에 보여지는 뷰입니다.
	var emptyView: some View {
		VStack(alignment: center) {
			
		}
	}
}


// MARK: - confirmButton (여행 On 선택 확인 버튼)

extension PlanCreateScreen {
	var confirmButton: some View {
		Button("확인") {
			viewModel.submit {
				presentationMode.wrappedValue.dismiss()
			} onError: { error in
				let apiError: APIError = error as! APIError
				viewModel.displayAlert(apiError.description)
			}
		}
	}
}


// MARK: - alertModal (Alert 모달)

extension PlanCreateScreen {
	var alertModal: Alert {
		Alert(
			title: Text("에러"),
			message: Text(viewModel.alertMessage),
			dismissButton: .default(Text("확인"))
		)
	}
}


// MARK: - Previews

struct PlanCreateScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlanCreateScreen()
    }
}
