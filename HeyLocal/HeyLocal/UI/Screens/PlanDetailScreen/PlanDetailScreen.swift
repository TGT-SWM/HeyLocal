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
	@StateObject var viewModel: ViewModel // 뷰 모델
	var plan: Plan // 대상이 되는 플랜 객체
	
	@Environment(\.dismiss) var dismiss
	@Environment(\.displayTabBar) var displayTabBar
	@Environment(\.navigateToTravelOnWithRegion) var navigateToTravelOnWithRegion
	
	
	init(plan: Plan) {
		self.plan = plan
		self._viewModel = StateObject(wrappedValue: ViewModel(plan: plan))
	}
	
    var body: some View {
		VStack(spacing: 0) {
			header
			dayControlView
			if (viewModel.showMapView) { mapView }
			else { scheduleView }
		}
		.background(Color("lightGray"))
		.animation(.easeInOut, value: viewModel.editMode)
		.navigationTitle("마이 플랜")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				BackButton { displayTabBar(true) }
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				editButton
			}
		}
		.onAppear {
			displayTabBar(false)
			if viewModel.schedules.isEmpty {
				viewModel.fetchPlaces()
			}
			if viewModel.shouldFetchCurrentLocation {
				viewModel.fetchCurrentLocation()
			}
		}
		.onChange(of: viewModel.shouldFetchCurrentLocation) { shouldFetch in
			if shouldFetch {
				viewModel.fetchCurrentLocation()
			}
		}
    }
	
	/// 스케줄 수정 모드로 진입하기 위한 버튼입니다.
	var editButton: some View {
		HStack {
			if viewModel.isEditing {
				Button("취소", action: viewModel.cancelChanges)
				Button("완료", action: viewModel.confirmChanges)
			} else {
				Button("편집", action: viewModel.startEditing)
			}
		}
	}
}


// MARK: - 상단 헤더 영역

extension PlanDetailScreen {
	/// 상단 헤더를 출력합니다.
	var header: some View {
		ZStack {
			Color.white
			HStack(alignment: .center, spacing: 0) {
				thumbnail
				headerTitleSection
				Spacer()
				mapToggleButton
			}
			
			.padding(.horizontal, 21)
			.padding(.vertical, 16)
		}
		.frame(height: 90)
		.padding(.bottom, 1)
	}
	
	/// 플랜의 썸네일을 출력합니다.
	var thumbnail: some View {
		AsyncImage(url: URL(string: plan.regionImageURL)!)
			.frame(width: 56, height: 56)
			.cornerRadius(.infinity)
	}
	
	/// 플랜의 제목과 여행 기간을 출력합니다.
	var headerTitleSection: some View {
		VStack(alignment: .leading) {
			headerPlanTitleSection
			Text(DateFormat.format(plan.startDate, from: "yyyy-MM-dd", to: "M월 d일") + " ~ " + DateFormat.format(plan.endDate, from: "yyyy-MM-dd", to: "M월 d일"))
				.font(.system(size: 12))
				.foregroundColor(Color("gray"))
		}
		.padding(.leading, 12)
	}
	
	/// 플랜 제목을 출력합니다.
	/// 수정 버튼을 눌러 플랜 제목을 수정할 수 있습니다.
	var headerPlanTitleSection: some View {
		HStack {
			if viewModel.isPlanTitleEditing {
				TextField("플랜 제목", text: viewModel.planTitle)
					.font(.system(size: 16))
				Button {
					viewModel.savePlanTitle()
				} label: {
					Image(systemName: "pencil")
				}
			} else {
				Text(viewModel.planTitle.wrappedValue)
					.font(.system(size: 16))
					.fontWeight(.medium)
				Button {
					viewModel.editPlanTitle()
				} label: {
					Image(systemName: "pencil")
				}
			}
		}
	}
	
	/// 스케줄 뷰 <-> 지도 뷰 전환 버튼입니다.
	var mapToggleButton: some View {
		Button {
			viewModel.showMapView.toggle()
		} label: {
			Image(systemName: viewModel.showMapView ? "map.fill" : "map")
				.font(.system(size: 24))
				.foregroundColor(.black)
		}
	}
}


// MARK: - 여행 일자 뷰

extension PlanDetailScreen {
	var dayControlView: some View {
		ZStack {
			Color.white
			HStack {
				Text("DAY \(viewModel.currentDay)")
					.font(.system(size: 14))
					.fontWeight(.medium)
				Text("\(viewModel.currentDate)")
					.font(.system(size: 14))
					.fontWeight(.medium)
					.foregroundColor(Color("gray"))
				Spacer()
				
				if viewModel.loadingLocation {
					loadingLocationMessage
				}
			}
			.padding(.horizontal, 27)
		}
		.frame(height: 40)
		.padding(.bottom, 7)
	}
	
	var loadingLocationMessage: some View {
		HStack(spacing: 4) {
			ProgressView()
				.scaleEffect(0.7, anchor: .center)
			Text("위치 로딩 중...")
				.font(.system(size: 14))
				.fontWeight(.medium)
				.foregroundColor(Color("gray"))
		}
	}
}


// MARK: - 스케줄 뷰

extension PlanDetailScreen {
	/// 스케줄 뷰를 출력합니다.
	var scheduleView: some View {
		TabView(selection: $viewModel.currentDay) {
			ForEach(viewModel.schedules.indices, id: \.self) {
				placeListOf(day: $0 + 1)
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
				KakaoMap(
					places: $viewModel.schedules[viewModel.currentDay - 1].places,
					showCurrentLocation: viewModel.isToday(day: viewModel.currentDay)
				)
			} else {
				KakaoMap(
					places: .constant([]),
					showCurrentLocation: viewModel.isToday(day: viewModel.currentDay)
				)
			}
		}
	}
}


// MARK: - Previews

struct PlanDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
		PlanDetailScreen(plan: Plan(id: 1, title: "서울, 서울, 서울!", regionId: 1, regionState: "서울특별시", regionCity: "강남구", startDate: "2022-09-01", endDate: "2022-09-03", transportationType: "OWN_CAR"))
    }
}
