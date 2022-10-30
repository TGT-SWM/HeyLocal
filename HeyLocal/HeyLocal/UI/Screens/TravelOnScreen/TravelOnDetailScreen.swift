//
//  TravelOnDetailScreen.swift
//  HeyLocal
//  여행On 상세조회 화면 (특정 여행On 조회)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

//TravelOnDetailScreen
struct TravelOnDetailScreen: View {
    @State var travelOnId: Int
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    @Environment(\.displayTabBar) var displayTabBar
    
    @State var showingSheet = false
    @State var showingAlert = false
    @State var navigationLinkActive = false
    
    var body: some View {
        ZStack(alignment: .center) {
            // 게시글 수정
            if navigationLinkActive {
                NavigationLink("", destination: TravelOnWriteScreen(isRevise: true, travelOnID: viewModel.travelOn.id), isActive: $navigationLinkActive)
            }
            
            ScrollView {
                content
                
                travelType
                
                ProfileComponent(author: viewModel.travelOn.author)
                
                opinions
            }
            // 삭제 Alert
            if showingAlert {
                CustomAlert(showingAlert: $showingAlert,
                            title: "삭제하시겠습니까?",
                            cancelMessage: "아니요,유지할래요",
                            confirmMessage: "네,삭제할래요",
                            cancelWidth: 134,
                            confirmWidth: 109,
                            rightButtonAction: {
                    viewModel.deleteTravelOn(travelOnId: viewModel.travelOn.id) },
                            destinationView: AnyView(TravelOnListScreen()))
            }
        }
        .onAppear {
            viewModel.fetchTravelOn(travelOnId: travelOnId)
            displayTabBar(false)
        }
        .navigationTitle("여행On")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton { displayTabBar(true) },
                            trailing: MoreButton(showingSheet: $showingSheet, showingAlert: $showingAlert, navigationLinkActive: $navigationLinkActive))
    }
    
    var travelDate: some View {
        VStack {
            
        }
    }
    
    
    /// 여행 취향
    var travelType: some View {
        VStack(alignment: .leading) {
            Text("나의 여행취향")
                .font(.system(size: 14))
                .foregroundColor(Color("gray"))
            
            HStack {
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
    
    
    
    var content: some View {
        VStack(alignment: .leading) {
            /// Title
            Group {
                Text("\(viewModel.travelOn.title)")
                    .font(.system(size: 22))
                    .fontWeight(.medium)
            }
            
            /// Upload Date - Region - Views
            Group {
                HStack {
                    // createdDateTime
                    let printDate = viewModel.travelOn.createdDateTime.components(separatedBy: "T")
                    let yyyyMMdd = printDate[0].components(separatedBy: "-")
                    Text("\(yyyyMMdd[0]).\(yyyyMMdd[1]).\(yyyyMMdd[2])")
                    
                    Spacer()
                        .frame(width: 10)
                    
                    // Region
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(regionNameFormatter(region: viewModel.travelOn.region))")
                    }
                    
                    Spacer()
                    
                    // Views
                    HStack(alignment: .bottom) {
                        Image("eye-alt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("조회수")
                        Text("\(viewModel.travelOn.views)")
                    }
                }
            }
            .font(.system(size: 12))
            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            
            /// 여행 출발일 - 여행 도착일
            Group {
                HStack {
                    VStack(alignment: .leading) {
                        let startDate = viewModel.travelOn.travelStartDate!.components(separatedBy: "-")
                        Text("여행 출발일")
                            .font(.system(size: 14))
                        
                        Spacer()
                            .frame(height: 4)
                        
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
                    
                    
                    VStack(alignment: .leading) {
                        let endDate = viewModel.travelOn.travelEndDate!.components(separatedBy: "-")
                        Text("여행 도착일")
                            .font(.system(size: 14))
                        
                        Spacer()
                            .frame(height: 4)
                        
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
            
            ///
            Group {
                Divider()
                
                VStack(alignment: .leading) {
                    Text("이런 여행 원해요!")
                        .font(.system(size: 22))
                        .fontWeight(.medium)

                    Divider()
                    
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading) {
                            Text("동행자")
                            Text("숙소형태")
                            Text("선호 음식")
                            Text("선호 음주류")
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
                                }
                                Text("떠나는 여행")
                            }
                            
                            /// 숙소형태
                            HStack {
                                // 가격 상관 없어요 선택 시
                                if viewModel.travelOn.accommodationMaxCost == 0 {
                                    Text("가격 상관없이")
                                }
                                else {
                                    Text("\(viewModel.travelOn.accommodationMaxCost! / 10000)만원 이하의 ")
                                }
        
                                // 숙소 어디든 선택 시
                                if viewModel.travelOn.hopeAccommodationSet![0].type == "ALL" {
                                    Text("숙소 어디든")
                                }
                                else {
                                    Group {
                                        ForEach(viewModel.travelOn.hopeAccommodationSet!) { accom in
                                            Text("\(accomToString(accom: accom.type))")
                                        }
                                    }
                                }
                            }
                            
                            /// 선호 음식
                            HStack {
                                Group {
                                    ForEach(viewModel.travelOn.hopeFoodSet!) { food in
                                        Text("\(foodToString(food: food.type))")
                                    }
                                }
                            }
                            
                            /// 선호 음주류
                            HStack {
                                if viewModel.travelOn.hopeDrinkSet![0].type == "NO_ALCOHOL" {
                                    Text("술은 안마셔요")
                                }
                                else {
                                    Group {
                                        ForEach(viewModel.travelOn.hopeDrinkSet!) { drink in
                                            Text("\(drinkToString(drink: drink.type))")
                                        }
                                    }
                                }
                            }
                            
                            /// 교통수단
                            Text("\(transToString(trans: viewModel.travelOn.transportationType!))")
                        }
                    }
                    .font(.system(size: 14))
                }
            }
            
            
//            // Description
//            Group {
//                Text("덧붙이자면,")
//                    .underline()
//                    .fontWeight(.medium)
//                    .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
//
//                ZStack(alignment: .topLeading) {
//                    Rectangle()
//                        .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
//                        .frame(width: 350, height: 160)
//                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
//                        .cornerRadius(10)
//
//
//                    Text("\(viewModel.travelOn.description)")
//                        .padding()
//                }
//            }
//            .font(.system(size: 14))
            
            Group {
                Spacer()
                    .frame(height: 10)
                
                HStack {
                    Spacer()
                    
                    /// 프로필 사진
                    if viewModel.travelOn.author.profileImgDownloadUrl == nil {
                        ZStack {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                    .frame(width: 20, height: 20)
                                    .shadow(color: .black, radius: 1)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 13, height: 13)
                                    .foregroundColor(Color("gray"))
                            }
                            
                            Circle()
                                .strokeBorder(.white, lineWidth: 1)
                                .frame(width: 20, height: 20)
                        }
                    }
                    // 프로필 사진이 있을 때
                    else {
                        AsyncImage(url: URL(string: viewModel.travelOn.author.profileImgDownloadUrl!)) { phash in
                            if let image = phash.image {
                                ZStack {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 20, height: 20)
                                        .shadow(color: .gray, radius: 3)
                                    
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 1)
                                        .frame(width: 20, height: 20)
                                }
                            }
                            else if phash.error != nil {
                                ZStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                            .frame(width: 20, height: 20)
                                            .shadow(color: .black, radius: 1)
                                        
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 13, height: 13)
                                            .foregroundColor(Color("gray"))
                                    }
                                    
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 1)
                                        .frame(width: 20, height: 20)
                                }
                            }
                            else {
                                ZStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                            .frame(width: 20, height: 20)
                                            .shadow(color: .black, radius: 1)
                                        
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 13, height: 13)
                                            .foregroundColor(Color("gray"))
                                    }
                                    
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 1)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        
                    }
                    
                    Text("\(viewModel.travelOn.author.nickname)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 117/255, green: 118/255, blue: 121/255))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }
            }
        }
        .padding()
    }
    
    // 답변
    @State var goToOpinionWrite: Bool = false
    var opinions: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text("이런 곳은 어때요?")
                        .font(.system(size: 22))
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button(action: {
                        goToOpinionWrite.toggle()
                        print(goToOpinionWrite.description)
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Spacer()
                                .frame(width: 5)
                            Text("나도 추천하기")
                        }
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    }
                    
                    NavigationLink(destination: OpinionWriteScreen(travelOnId: travelOnId), isActive: $goToOpinionWrite) {
                        EmptyView()
                    }
                    
                    
//                    NavigationLink(destination: OpinionWriteScreen(travelOnId: travelOnId), isActive: $goToOpinionWrite) {
//                        HStack {
//                            Image(systemName: "plus")
//                            Spacer()
//                                .frame(width: 5)
//                            Text("나도 추천하기")
//                        }
//                        .font(.system(size: 12))
//                        .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
//                    }
//
                    
                }
                
                //해당 여행On 답변 출력
                OpinionListScreen(travelOnId: travelOnId)
                
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
            }
        }
        .frame(width: 350)
        .padding()
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

struct TravelOnDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnDetailScreen(travelOnId: 32)
    }
}


