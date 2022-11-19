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
	@Environment(\.displayTabBar) var displayTabBar
	
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
			.onAppear {
				displayTabBar(true)
				viewModel.clearStates()
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
			writeTravelOnView
			
			ForEach(viewModel.travelOns, id: \.id) { listItem($0) }
			
			// 더 이상 로드할 컨텐츠가 없는 경우 표시하지 않습니다.
			if !viewModel.isEnd {
				ProgressView()
					.onAppear {
						viewModel.fetchTravelOns()
						print("onAppear")
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
	
	/// 여행 On 작성 화면으로 이동하기 위한 뷰입니다.
	var writeTravelOnView: some View {
		HStack(alignment: .center) {
			VStack(alignment: .center, spacing: 28) {
				Text("원하는 여행 On이 없다면?")
					.foregroundColor(Color("gray"))
					.font(.system(size: 16))
					.fontWeight(.medium)
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets())
				
				NavigationLink(destination: TravelOnWriteScreen()) {
					Text("여행 On 작성하기")
						.font(.system(size: 14))
						.fontWeight(.medium)
						.foregroundColor(.white)
						.background(
							RoundedRectangle(cornerRadius: 100)
								.fill(Color("orange"))
								.frame(width: 150, height: 38)
						)
				}
				.buttonStyle(PlainButtonStyle())
			}
		}
		.frame(height: 200)
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
