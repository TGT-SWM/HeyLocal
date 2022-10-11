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
    @StateObject var opinionViewModel = OpinionComponent.ViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var showingSheet = false
    @State var showingAlert = false
    
    // custom Back button
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .foregroundColor(.black)
        }
    }
    
    // Navigation Bar Item : 수정·삭제 ActionSheet 보기
    var moreBtn: some View {
        Button(action: {
            showingSheet.toggle()
        }) {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .frame(width: 14)
                .foregroundColor(.black)
                .rotationEffect(.degrees(-90))
        }
        .confirmationDialog("", isPresented: $showingSheet, titleVisibility: .hidden) { //actionsheet
             Button("게시글 수정") {
                 navigationLinkActive = true
             }
             Button("삭제", role: .destructive) {
                 showingAlert.toggle()
             }
             Button("취소", role: .cancel) {
             }
        }
    }
    
    @State var navigationLinkActive = false
    var body: some View {
        ZStack(alignment: .center) {
            // 게시글 수정 
            if navigationLinkActive {
                NavigationLink("", destination: TravelOnWriteScreen(isRevise: true, travelOnID: viewModel.travelOn.id), isActive: $navigationLinkActive)
            }
            
            ScrollView {
                content
                
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
                    viewModel.deleteTravelOn(travelOnId: viewModel.travelOn.id) }, destinationView: AnyView(TravelOnListScreen()))
            }
        }
        .onAppear {
            viewModel.fetchTravelOn(travelOnId: travelOnId)
            opinionViewModel.fetchOpinions(travelOnId: travelOnId)
        }
        .navigationTitle("여행On")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: moreBtn)
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            // Title
            Group {
                Text("\(viewModel.travelOn.title)")
                    .font(.system(size: 22))
                    .fontWeight(.medium)
            }
            
            // Upload Date - Region - Views
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
                        Image("pin_black_icon")
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
                        Image("view_icon")
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
            
            
            // TODO: When + Member + Where
            Group {
                VStack(alignment: .leading) {
                    HStack {
                        let startDate = viewModel.travelOn.travelStartDate!.components(separatedBy: "-")
                        let endDate = viewModel.travelOn.travelEndDate!.components(separatedBy: "-")
                        
                        Text("\(startDate[1])월 \(startDate[2])일부터 \(endDate[1])월 \(endDate[2])일에")
                            .underline()
                    }
                    
                    HStack {
                        ForEach(viewModel.travelOn.travelMemberSet!) { member in
                            Text("\(memToString(mem: member.type))")
                                .underline()
                        }
                        
                        Text("가는")
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        
                        Text("\(regionNameFormatter(region: viewModel.travelOn.region)) 여행")
                            .underline()
                    }
                }
                
            }
            .font(.system(size: 14))
            .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            Spacer()
                .frame(height: 20)
            
            // Taste + Accom + Food + Drink
            Group {
                VStack (alignment: .leading){
                    // Taste
                    HStack {
                        
                    }
                    
                    // Accom
                    HStack {
                        // 가격 상관 없어요 선택 시
                        if viewModel.travelOn.accommodationMaxCost == 0 {
                            Text("가격 상관없이")
                                .underline()
                                .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                        }
                        else {
                            Text("\(viewModel.travelOn.accommodationMaxCost! / 10000)만원 이하의 ")
                                .underline()
                                .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                        }
                        
                        
                        // 숙소 어디든 선택 시
                        if viewModel.travelOn.hopeAccommodationSet![0].type == "ALL" {
                            Text("숙소 어디든")
                                .underline()
                                .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                        }
                        else {
                            Group {
                                ForEach(viewModel.travelOn.hopeAccommodationSet!) { accom in
                                    Text("\(accomToString(accom: accom.type))")
                                        .underline()
                                }
                            }
                            .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                        }
                        Text("추천해주세요!")
                    }
                    
                    // Food
                    HStack {
                        Group {
                            ForEach(viewModel.travelOn.hopeFoodSet!) { food in
                                Text("\(foodToString(food: food.type))")
                                    .underline()
                            }
                        }
                        .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                        
                        Text("을 추천해주세요!")
                    }
                    
                    // Drink
                    HStack {
                        if viewModel.travelOn.hopeDrinkSet![0].type == "NO_ALCOHOL" {
                            Text("술은 안마셔요")
                        }
                        else {
                            Group {
                                ForEach(viewModel.travelOn.hopeDrinkSet!) { drink in
                                    Text("\(drinkToString(drink: drink.type))")
                                        .underline()
                                }
                            }
                            .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                            
                            Text("을 추천해주세요!")
                        }
                    }
                }
            }
            .font(.system(size: 14))
            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            
            Spacer()
                .frame(height: 20)
            
            // Transportation
            Group {
                HStack {
                    Text("주로")
                    
                    Text("\(transToString(trans: viewModel.travelOn.transportationType!))")
                        .underline()
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                    
                    Spacer()
                        .frame(width: 2)
                
                    Text("을 이용하여 움직입니다.")
                }
            }
            .font(.system(size: 14))
            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            
            Spacer()
                .frame(height: 10)
            
            // Description
            Group {
                Text("덧붙이자면,")
                    .underline()
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .frame(width: 350, height: 160)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .cornerRadius(10)
                    
                    
                    Text("\(viewModel.travelOn.description)")
                        .padding()
                }
            }
            .font(.system(size: 14))
            
            Group {
                Spacer()
                    .frame(height: 10)
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                            .frame(width: 20, height: 20)
                            .shadow(color: .black, radius: 1)
                            
                        
                        Circle()
                            .strokeBorder(.white, lineWidth: 1)
                            .frame(width: 20, height: 20)
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
    var opinions: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text("이런 곳은 어때요?")
                        .font(.system(size: 22))
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    // TODO: Navigation Link
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "plus")
                            Spacer()
                                .frame(width: 5)
                            Text("나도 추천하기")
                        }
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    }
                }
                
                //해당 여행On 답변 출력
                VStack(alignment: .leading) {
                    ForEach(opinionViewModel.opinions) { opinion in
                        ZStack(alignment: .bottomTrailing) {
                            NavigationLink(destination: OpinionDetailScreen(travelOnId: travelOnId, opinionId: opinion.id)) {
                                OpinionComponent(opinion: opinion)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                            }
                            
                            // TODO: 플랜에 장소 추가하는 기능
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 255/255, green: 153/255, blue: 0/255))
                                    .frame(width: 90, height: 24)
                                    .cornerRadius(14)
                                
                                HStack(alignment: .center) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 13)
                                        .foregroundColor(Color.white)
                                    
                                    Text("플랜에 추가")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.white)
                                }
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        }
                    }
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


