//
//  PlanDetailScreen.swift
//  HeyLocal
//	플랜 상세 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

// MARK: - PlanDetailScreen (플랜 상세 화면)

struct PlanDetailScreen: View {
	@ObservedObject var viewModel: ViewModel // 뷰 모델
	var plan: Plan // 대상이 되는 플랜 객체
	
	init(plan: Plan) {
		self.plan = plan
		self.viewModel = ViewModel(plan: plan)
	}
	
    var body: some View {
		VStack {
			header
			if (viewModel.showMapView) { mapView }
			else { scheduleView }
			dayControlButtons
		}
		.navigationTitle("마이 플랜")
		.navigationBarTitleDisplayMode(.inline)
		.animation(.easeInOut, value: viewModel.editMode)
		.toolbar { editButton }
    }
	
	/// 일자 이동을 위한 버튼입니다.
	var dayControlButtons: some View {
		HStack {
			Button("이전") { viewModel.goPrevDay() }
				.disabled(viewModel.isFirstDay)
			Button("다음") { viewModel.goNextDay() }
				.disabled(viewModel.isLastDay)
		}
		.padding()
	}
	
	/// 스케줄 수정 모드로 진입하기 위한 버튼입니다.
	var editButton: some View {
		HStack {
			if viewModel.isEditing {
				Button("취소", action: viewModel.cancelChanges)
				Button("확인", action: viewModel.confirmChanges)
			} else {
				Button("수정", action: viewModel.startEditing)
			}
		}
	}
}


// MARK: - 상단 헤더 영역

extension PlanDetailScreen {
	/// 상단 헤더를 출력합니다.
	var header: some View {
		HStack {
			headerTitleSection
			Spacer()
			headerDaySection
			mapToggleButton
		}
		.padding()
	}
	
	/// 플랜의 제목과 여행 기간을 출력합니다.
	var headerTitleSection: some View {
		VStack(alignment: .leading) {
			headerPlanTitleSection
			Text(DateFormat.format(plan.startDate, from: "yyyy-MM-dd", to: "M월 d일") + " ~ " + DateFormat.format(plan.endDate, from: "yyyy-MM-dd", to: "M월 d일"))
				.font(.subheadline)
		}
	}
	
	/// 플랜 제목을 출력합니다.
	/// 수정 버튼을 눌러 플랜 제목을 수정할 수 있습니다.
	var headerPlanTitleSection: some View {
		HStack {
			if viewModel.isPlanTitleEditing {
				TextField("플랜 제목", text: viewModel.planTitle)
					.font(.title2)
				Button {
					viewModel.savePlanTitle()
				} label: {
					Image(systemName: "pencil")
				}
			} else {
				Text(viewModel.planTitle.wrappedValue)
					.font(.title2)
					.fontWeight(.bold)
				Button {
					viewModel.editPlanTitle()
				} label: {
					Image(systemName: "pencil")
				}
			}
		}
	}
	
	/// 현재 보고 있는 플랜 일자를 출력합니다.
	var headerDaySection: some View {
		VStack(alignment: .center) {
			Text("\(viewModel.currentDay)일차")
			Text("(\(viewModel.currentDate)일)")
		}.padding(.trailing, 5)
	}
	
	/// 스케줄 뷰 <-> 지도 뷰 전환 버튼입니다.
	var mapToggleButton: some View {
		Button {
			viewModel.showMapView.toggle()
		} label: {
			Image(systemName: viewModel.showMapView ? "map.fill" : "map")
				.font(.system(size: 24))
		}
	}
}


// MARK: - 스케줄 뷰

extension PlanDetailScreen {
	/// 스케줄 뷰를 출력합니다.
	var scheduleView: some View {
		VStack {
			if !viewModel.schedules.isEmpty { addPlacesButton }
			scheduleTabs
		}
	}
	
	/// 장소 검색 화면으로 이동해 스케줄에 장소들을 추가하기 위한 버튼입니다.
	var addPlacesButton: some View {
		NavigationLink(
			destination: PlaceSearchScreen(onComplete: viewModel.handleAddPlaces)
		) {
			Text("해당 일자에 장소 추가하기")
		}
		.padding()
	}
	
	/// 스케줄을 일자별 탭으로 나누어 출력합니다.
	var scheduleTabs: some View {
		TabView(selection: $viewModel.currentDay) {
			ForEach(viewModel.schedules.indices, id: \.self) {
				PlaceList(places: viewModel.scheduleOf($0 + 1))
					.tag($0 + 1)
					.environment(\.editMode, $viewModel.editMode)
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
	}
}


// MARK: - 지도 뷰

extension PlanDetailScreen {
	/// 지도 뷰를 출력합니다.
	var mapView: some View {
		VStack {
			if !viewModel.schedules.isEmpty {
				KakaoMap(places: $viewModel.schedules[viewModel.currentDay - 1].places)
			} else {
				KakaoMap(places: .constant([]))
			}
		}
	}
}


// MARK: - Previews

struct PlanDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
		PlanDetailScreen(plan: Plan(id: 1, title: "서울, 서울, 서울!", regionId: 1, regionState: "서울특별시", regionCity: "강남구", startDate: "2022-09-01", endDate: "2022-09-03"))
    }
}
