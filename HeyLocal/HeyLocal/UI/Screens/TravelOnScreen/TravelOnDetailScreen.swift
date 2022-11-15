//
//  TravelOnDetailScreen.swift
//  HeyLocal
//  여행On 상세조회 화면 (특정 여행On 조회)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import AVFAudio

//TravelOnDetailScreen
struct TravelOnDetailScreen: View {
    @State var travelOnId: Int
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.displayTabBar) var displayTabBar
    
    @State var showingSheet = false
    @State var showingAlert = false
    @State var showingReportAlert = false
    @State var showingModal = false
    @State var navigationLinkActive = false
    
    var body: some View {
        ZStack(alignment: .center) {
            // 게시글 수정
//            if navigationLinkActive {
//                NavigationLink("", destination: TravelOnWriteScreen(isRevise: true, travelOnID: viewModel.travelOn.id), isActive: $navigationLinkActive)
//            }
//
            NavigationLink(destination: TravelOnWriteScreen(isRevise: true, travelOnID: viewModel.travelOn.id), isActive: $navigationLinkActive) {
                Text("")
            }
            
            ScrollView {
                travelDate
                Spacer()
                    .frame(height: 8)
                
                travelInfo
                Spacer()
                    .frame(height: 8)
                
                ProfileComponent(author: viewModel.travelOn.author)
                Spacer()
                    .frame(height: 8)
                
                TravelOnOpinion(travelon: viewModel.travelOn, travelOnId: travelOnId, showingModal: $showingModal, regionId: viewModel.travelOn.region.id)
                    .alert(isPresented: $showingReportAlert) {
                        Alert(title: Text("여행On 신고"),
                              message: Text("해당 여행On을 신고할까요?"),
                              primaryButton: .destructive(Text("신고"), action: {}),
                              secondaryButton: .cancel(Text("취소")))
                    }
            }

//            // 삭제 Alert
            if showingAlert {
                CustomAlert(showingAlert: $showingAlert,
                            title: "삭제하시겠습니까?",
                            cancelMessage: "아니요,유지할래요",
                            confirmMessage: "네,삭제할래요",
                            cancelWidth: 134,
                            confirmWidth: 109,
                            rightButtonAction: {
                                viewModel.deleteTravelOn(travelOnId: viewModel.travelOn.id)
                                dismiss()
                            })
            }
            
            // 예외처리
            if showingModal {
                ConfirmModal(title: "안내",
                             message: "지역이 같은 사용자만 답변 등록이 가능합니다.",
                             showModal: $showingModal)
            }
            
        }
        .background(Color("lightGray"))
        .onAppear {
            viewModel.fetchTravelOn(travelOnId: travelOnId)
            displayTabBar(false)
        }
        .navigationTitle("여행On")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton { displayTabBar(true) },
                            trailing: MoreButton(showingSheet: $showingSheet,
                                                 showingAlert: $showingAlert,
                                                 showingReportAlert: $showingReportAlert,
                                                 navigationLinkActive: $navigationLinkActive,
                                                 authId: viewModel.travelOn.author.id))
    }
    
    
    var travelDate: some View {
        VStack(alignment: .leading) {
            Group {
                /// 여행On 제목
                Text("\(viewModel.travelOn.title)")
                    .font(.system(size: 22))
                    .fontWeight(.medium)
                
                Spacer()
                    .frame(height: 7)
                
                /// 등록일 · 여행 지역
                HStack {
                    let printDate = viewModel.travelOn.createdDateTime.components(separatedBy: "T")
                    let yyyyMMdd = printDate[0].components(separatedBy: "-")
                    
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 13)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(regionNameFormatter(region: viewModel.travelOn.region))")
                    }
                    
                    Spacer()
                    
                    Text("\(yyyyMMdd[0]).\(yyyyMMdd[1]).\(yyyyMMdd[2])")
                }
                .foregroundColor(Color("gray"))
                .font(.system(size: 12))
            }
            
            Spacer()
                .frame(height: 20)
            
            /// 여행 출발일 · 여행 도착일
            HStack {
                VStack(alignment: .leading) {
                    let startDate = viewModel.travelOn.travelStartDate!.components(separatedBy: "-")
                    Text("여행 시작일")
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(height: 6)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                            .frame(width: 171, height: 36)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                            .cornerRadius(10)
                        
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            
                            Image("calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                            
                            Text("\(startDate[0])-\(startDate[1])-\(startDate[2])")
                                .font(.system(size: 14))
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    let endDate = viewModel.travelOn.travelEndDate!.components(separatedBy: "-")
                    Text("여행 종료일")
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(height: 6)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                            .frame(width: 171, height: 36)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                            .cornerRadius(10)
                        
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            
                            Image("calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                            
                            Text("\(endDate[0])-\(endDate[1])-\(endDate[2])")
                                .font(.system(size: 14))
                        }
                    }
                }
            }
        }
        .padding()
        .background(.white)
    }
    
    
    /// Travel-On 정보
    var travelInfo: some View {
        VStack(alignment: .leading) {
            
            Text("이런 여행 원해요!")
                .font(.system(size: 22))
                .fontWeight(.medium)
                .padding()
            
            Spacer()
                .frame(height: 0)
            Divider()
            
            // 여행 정보
            Group {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        Text("동행자")
                        Spacer()
                            .frame(height: 5)
                        
                        Text("숙소형태")
                        Spacer()
                            .frame(height: 5)
                        
                        Text("선호 음식")
                        Spacer()
                            .frame(height: 5)
                        
                        Text("선호 음주류")
                        Spacer()
                            .frame(height: 5)
                        
                        Text("교통수단")
                    }
                    .foregroundColor(Color("gray"))
                    
                    Spacer()
                        .frame(width: 20)
                    
                    VStack(alignment: .leading) {
                        /// 동행자
                        HStack {
                            ForEach(viewModel.travelOn.travelMemberSet!) { member in
                                Text("\(memToString(mem: member.type))")
                                
                                Spacer()
                                    .frame(width: 1)
                                
                                if member.type != viewModel.travelOn.travelMemberSet![viewModel.travelOn.travelMemberSet!.count - 1].type {
                                    Text(", ")
                                }
                                
                                Spacer()
                                    .frame(width: 3)
                            }
                            
                            Text("떠나는 여행")
                        }
                        Spacer()
                            .frame(height: 5)
                        
                        /// 숙소형태
                        HStack {
                            // 가격 상관 없어요 선택 시
                            if viewModel.travelOn.accommodationMaxCost == 0 {
                                Text("가격 상관없이")
                            }
                            else {
                                Text("\(viewModel.travelOn.accommodationMaxCost! / 10000)만원 이하의 ")
                            }
                            
                            Spacer()
                                .frame(width: 2)
    
                            // 숙소 어디든 선택 시
                            if viewModel.travelOn.hopeAccommodationSet![0].type == "ALL" {
                                Text("숙소 어디든")
                            }
                            else {
                                Group {
                                    ForEach(viewModel.travelOn.hopeAccommodationSet!) { accom in
                                        Text("\(accomToString(accom: accom.type))")
                                        
                                        if accom.type != viewModel.travelOn.hopeAccommodationSet![viewModel.travelOn.hopeAccommodationSet!.count - 1].type {
                                            Text(", ")
                                        }
                                        
                                        Spacer()
                                            .frame(width: 3)
                                    }
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 5)
                        
                        /// 선호 음식
                        HStack {
                            Group {
                                ForEach(viewModel.travelOn.hopeFoodSet!) { food in
                                    Text("\(foodToString(food: food.type))")
                                    
                                    Spacer()
                                        .frame(width: 1)
                                    
                                    if food.type != viewModel.travelOn.hopeFoodSet![viewModel.travelOn.hopeFoodSet!.count - 1].type {
                                        Text(", ")
                                    }
                                    
                                    Spacer()
                                        .frame(width: 3)
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 5)
                        
                        /// 선호 음주류
                        HStack {
                            if viewModel.travelOn.hopeDrinkSet![0].type == "NO_ALCOHOL" {
                                Text("술은 안마셔요")
                            }
                            else {
                                Group {
                                    ForEach(viewModel.travelOn.hopeDrinkSet!) { drink in
                                        Text("\(drinkToString(drink: drink.type))")
                                        
                                        Spacer()
                                            .frame(width: 1)
                                        
                                        if drink.type != viewModel.travelOn.hopeDrinkSet![viewModel.travelOn.hopeDrinkSet!.count - 1].type {
                                            Text(", ")
                                        }
                                        
                                        Spacer()
                                            .frame(width: 3)
                                    }
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 5)

                        
                        /// 교통수단
                        Text("\(transToString(trans: viewModel.travelOn.transportationType!))")
                    }
                }
                .font(.system(size: 14))
            }
            .padding()
            
            Divider()
            
            // 여행 취향
            Group {
                VStack(alignment: .leading) {
                    Text("나의 여행취향")
                        .font(.system(size: 14))
                        .foregroundColor(Color("gray"))
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        // place type
                        Group {
                            if viewModel.travelOn.travelTypeGroup?.placeTasteType == "FAMOUS" {
                                Image("PlaceType_popular_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("PlaceType_new_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Spacer()
                        
                        // activity type
                        Group {
                            if viewModel.travelOn.travelTypeGroup?.activityTasteType == "HARD" {
                                Image("ActivityType_busy_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("ActivityType_slow_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Spacer()
                        
                        Group {
                            if viewModel.travelOn.travelTypeGroup?.snsTasteType == "YES" {
                                Image("SnsType_yes_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("SnsType_no_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Divider()
            
            // 상세 설명
            Group {
                VStack(alignment: .leading) {
                    Text("상세한 요구사항이 있나요?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("gray"))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text("\(viewModel.travelOn.description)")
                        .font(.system(size: 14))
                }
            }
            .padding()
        }
        .background(.white)
    }
    
    func memToString(mem: String) -> String {
        switch mem {
        case "ALONE":
            return "혼자"
        case "CHILD":
            return "아이와"
        case "PARENT":
            return "부모님과"
        case "COUPLE":
            return "연인과"
        case "FRIEND":
            return "친구와"
        case "PET":
            return "반려동물과"
        default:
            return ""
        }
    }
    
    func accomToString(accom: String) -> String {
        switch accom {
        case "HOTEL":
            return "호텔"
        case "PENSION":
            return "펜션"
        case "CAMPING":
            return "캠핑/글램핑"
        case "GUEST_HOUSE":
            return "게스트하우스"
        case "RESORT":
            return "리조트"
        case "ALL":
            return "상관 없어요"
        default:
            return ""
        }
    }
    
    func transToString(trans: String) -> String {
        switch trans {
        case "OWN_CAR":
            return "자가용"
        case "RENT_CAR":
            return "렌트카"
        case "PUBLIC":
            return "대중교통"
        default:
            return ""
        }
    }
    
    func foodToString(food: String) -> String {
        switch food {
        case "KOREAN":
            return "한식"
        case "WESTERN":
            return "양식"
        case "CHINESE":
            return "중식"
        case "JAPANESE":
            return "일식"
        case "GLOBAL":
            return "세계음식"
        default:
            return ""
        }
    }
    
    func drinkToString(drink: String) -> String {
        switch drink {
        case "SOJU":
            return "소주"
        case "BEER":
            return "맥주"
        case "WINE":
            return "와인"
        case "MAKGEOLLI":
            return "막걸리"
        case "LIQUOR":
            return "칵테일"
        case "NO_ALCOHOL":
            return "술 안마셔요"
        default:
            return ""
        }
    }
}



extension TravelOnDetailScreen {
    struct TravelOnOpinion: View {
        @StateObject var viewModel = TravelOnListScreen.ViewModel()
        @StateObject var planViewModel = PlanCreateScreen.ViewModel()
        var travelOnRepository = TravelOnRepository()
        
        
        var travelon: TravelOn
        var travelOnId: Int
        @Binding var showingModal: Bool
        var regionId: Int
        @State var opinionWriteActive: Bool = false
        @State var planNavigationActive: Bool = false
        @State var plan: Plan = Plan(id: 0,
                                     title: "마이플랜",
                                     regionId: 0,
                                     regionState: "",
                                     startDate: "2022-11-13",
                                     endDate: "2022-11-13",
                                     transportationType: "OWN_CAR")
        
        var body: some View {
            VStack(alignment: .leading) {
                Group {
                    Text("이런 곳은 어때요?")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .padding()
                    
                    Spacer()
                        .frame(height: 0)
                    
                    // 내 프로필 · 답변 쓰기 버튼
                    HStack {
                        if viewModel.profile.profileImgDownloadUrl != nil {
                            AsyncImage(url: URL(string: viewModel.profile.profileImgDownloadUrl!)) { phash in
                                if let image = phash.image {
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 48, height: 48)
                                }
                                else {
                                    ZStack {
                                        Circle()
                                            .fill(Color("lightGray"))
                                            .frame(width: 48, height: 48)
                                            .shadow(color: Color("gray"), radius: 1)
                                        
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 27, height: 27)
                                            .foregroundColor(Color("gray"))
                                    }
                                }
                            }
                        }
                        else {
                            ZStack {
                                Circle()
                                    .fill(Color("lightGray"))
                                    .frame(width: 48, height: 48)
                                    .shadow(color: Color("gray"), radius: 1)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 27, height: 27)
                                    .foregroundColor(Color("gray"))
                            }
                        }
                        
                        Spacer()
                        
                        if viewModel.profile.id == travelon.author.id {
                            // 마이플랜 생성 
                            Button(action: {
                                planViewModel.selected = travelon
                                planViewModel.submit{
									travelOnRepository.getPlan(travelOnId: travelOnId) { plan in
										self.plan = plan
										planNavigationActive.toggle()
									}
                                    
                                } onError : { error in
                                    let apiError: APIError = error as! APIError
                                    planViewModel.displayAlert(apiError.description)
                                    
									travelOnRepository.getPlan(travelOnId: travelOnId) { plan in
										self.plan = plan
										planNavigationActive.toggle()
									}
                                }
                            }) {
                                // Label
                                ZStack {
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(Color("orange"))
                                        .frame(width: 300, height: 44)
                                    
                                    Text("해당 마이플랜으로 이동하기")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        else {
                            // 답변쓰기 버튼
                            Button(action: {
                                if let region = viewModel.profile.activityRegion {
                                    if region.id == regionId {
                                        opinionWriteActive.toggle()
                                    }
                                    else {
                                        // 지역이 같은 유저만 가능한 ~
                                        showingModal.toggle()
                                    }
                                } else {
                                    // 지역 설정이 필요 , 또한 지역이 같은 유저만 가능한 ~
                                    showingModal.toggle()
                                }
                            }) {
                                // Label
                                ZStack {
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(Color("orange"))
                                        .frame(width: 300, height: 44)
                                    
                                    Text("나도 추천하기")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        if planNavigationActive {
                            NavigationLink(destination: PlanDetailScreen(plan: plan), isActive: $planNavigationActive){
                                Text("")
                            }
                        }
                        
                        NavigationLink(destination: OpinionWriteScreen(travelOnId: travelOnId), isActive: $opinionWriteActive) {
                            Text("")
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                }
            
                Divider()
                
                //해당 여행On 답변 출력
                OpinionListScreen(travelOnId: travelOnId)
            }
            .onAppear {
                viewModel.getMyProfile()
            }
            .background(.white)
        }
    }
}

struct TravelOnDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnDetailScreen(travelOnId: 32)
    }
}


