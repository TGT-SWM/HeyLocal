//
//  OpinionDetailScreen.swift
//  HeyLocal
//  답변 상세조회 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI


struct OpinionDetailScreen: View {
    // custom Back button
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayTabBar) var displayTabBar
    
    // Navigation Bar Item : 수정·삭제 ActionSheet 보기
    @State var showingSheet = false
    @State var showingAlert = false
    @State var navigationLinkActive = false

    
    @StateObject var viewModel = OpinionComponent.ViewModel()
    var travelOnId: Int
    var opinionId: Int
    var body: some View {
        ZStack(alignment: .center) {
            if navigationLinkActive {
                NavigationLink("", destination: OpinionWriteScreen(opinionId: opinionId, travelOnId: travelOnId), isActive: $navigationLinkActive)
            }
            
            ZStack(alignment: .bottom) {
                
                ScrollView {   
                    content
                        .padding()
                }
                user
            }
            if showingAlert {
                CustomAlert(showingAlert: $showingAlert,
                            title: "삭제하시겠습니까?",
                            cancelMessage: "아니요,유지할래요",
                            confirmMessage: "네,삭제할래요",
                            cancelWidth: 134,
                            confirmWidth: 109,
                            rightButtonAction: { viewModel.deleteOpinion(travelOnId: travelOnId, opinionId: opinionId) })
            }
        }
        .onAppear {
            viewModel.fetchOpinions(travelOnId: travelOnId, opinionId: opinionId)
            displayTabBar(false)
        }
        .navigationTitle("답변 상세")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton { displayTabBar(true) },
                            trailing: MoreButton(showingSheet: $showingSheet, showingAlert: $showingAlert, navigationLinkActive: $navigationLinkActive))
    }
    
    
    var content: some View {
        VStack(alignment: .leading) {
            // 장소명, 시간, region, 사진, description
            Group {
                HStack {
                    Text("\(viewModel.opinion.place.name)")
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Group {
                        Button("수정") {
                            navigationLinkActive = true
                        }
                        Button("삭제") {
                            showingAlert.toggle()
                        }
                    }
                    .foregroundColor(Color(red: 117/255, green: 118/255, blue: 121/255))
                }
                .font(.system(size: 16))
                
                
                HStack {
                    let printDate = viewModel.opinion.createdDate.components(separatedBy: "T")
                    let yyyyMMdd = printDate[0].components(separatedBy: "-")
                    Text("\(yyyyMMdd[0]).\(yyyyMMdd[1]).\(yyyyMMdd[2])")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 117/255, green: 118/255, blue: 121/255))
                    
                    HStack {
                        Image("pin_black_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(viewModel.opinion.place.address)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                }
                
                
                // TODO: 이미지
                
                Text("\(viewModel.opinion.description)")
                    .font(.system(size: 14))
            }
            
            Divider()
            
            // 공통 질문
            common
            
            // 카테고리별 질문
            switch viewModel.opinion.place.category {
            case "FD6": // 음식점
                food
                
            case "CE7": // 식당
                cafe
                
            case "CT1": // 문화시설
                sightseeing
                
            case "AT4": // 관광명소
                sightseeing
                
            case "AD5": // 숙박
                accommodation
            
            default:
                Text("")
            }
        }
    }
    
    
    // MARK: - '기타' · '공통' 답변
    var common: some View {
        VStack(alignment: .leading) {
            Group {
                Text("어떤 점이 좋았나요?")
                    .font(.system(size: 16))
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 5, trailing: 0))
                
                
                Group {
                    Text("✨ 청결도")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    
                    OpinionStyle(label: "\(facilityToString(facility: viewModel.opinion.facilityCleanliness))")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                
                
                Group {
                    Text("🔧 시설")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    OpinionStyle(label: parkingToString(parking: viewModel.opinion.canParking))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                
                
                Text("💰 비용")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                HStack {
                    OpinionStyle(label: costToString(cost: viewModel.opinion.costPerformance))
                    OpinionStyle(label: waitingToString(waiting: viewModel.opinion.waiting))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }
    }
    
    // MARK: - '음식점' 답변
    var food: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("추가의견")
                .font(.system(size: 16))
            
            Text("가게 분위기는 어떤가요")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: restaurantMoodToString(mood: viewModel.opinion.restaurantMoodType!))
            
            Text("추천하는 메뉴는 무엇인가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "\(viewModel.opinion.recommendFoodDescription)")
            
            
        }
    }
    
    // MARK: - '카페' 답변
    var cafe: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("추가의견")
                .font(.system(size: 16))
            
            Text("커피 스타일은 어떤가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: coffeeToString(coffee: viewModel.opinion.coffeeType!))
            
            
            Text("추천하는 음료·디저트는 무엇인가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "\(viewModel.opinion.recommendDrinkAndDessertDescription)")
            
            Text("카페 분위기는 어떤가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: cafeMoodToString(mood: viewModel.opinion.cafeMoodType!))
            
            
        }
    }
    
    // MARK: - '문화시설' · '관광명소' 답변
    var sightseeing: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("추가의견")
                .font(.system(size: 16))
            
            Text("여기서 꼭 해봐야 하는 게 있나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "\(viewModel.opinion.recommendToDo)")
            
            Text("여기서 추천하는 간식이 있나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "\(viewModel.opinion.recommendSnack)")
            
            Text("여기의 사진 명소는 어디인가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "\(viewModel.opinion.photoSpotDescription)")
        }
    }
    
    // MARK: - '숙박' 답변
    var accommodation: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("추가의견")
                .font(.system(size: 16))
            
            Text("주변이 시끄럽나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: noiseToString(noise: viewModel.opinion.streetNoise!))
            
            Text("방음이 잘 되나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: deafeningToString(deafening: viewModel.opinion.deafening!))
            
            Text("조식이 나오나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: viewModel.opinion.hasBreakFast! ? "조식이 나와요" : "조식은 없어요")
            
        }
    }
    
    
    
    // MARK: - 작성자 정보
    var user: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(red: 85/255, green: 85/255, blue: 85/255))
                .frame(width: ScreenSize.width, height: 136)
            
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .frame(width: 56, height: 56)
                    
                    Spacer()
                        .frame(width: 15)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(regionNameFormatter(region: viewModel.opinion.author.activityRegion))")
                            .font(.system(size: 12))
                        
                        Text("\(viewModel.opinion.author.nickname)")
                            .font(.system(size: 16))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 3) {
                            Image("comment_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                            
                            Text("답변수")
                            Text("\(viewModel.opinion.author.totalOpinionCount!)")
                        }
                        
                        HStack(alignment: .center, spacing: 3) {
                            Image("heart_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                            
                            Text("채택수")
                            Text("\(viewModel.opinion.author.acceptedOpinionCount!)")
                        }
                    }
                    .font(.system(size: 12))
                }
                
                Spacer()
                    .frame(height: 15)
                
                Text("\(viewModel.opinion.author.introduce)")
                    .font(.system(size: 12))
                
            } // vstack
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
            .foregroundColor(Color.white)
        } // zstack
    } // user
    
    
    // MARK: - 5점척도 to String
    func facilityToString(facility: String) -> String {
        var result: String = ""
        switch facility {
        case "VERY_BAD":
            result = "시설이 더러워요"

        case "BAD":
            result = "시설이 청결하지 않아요"

        case "NOT_BAD":
            result = "시설 청결도가 그저 그래요"

        case "GOOD":
            result = "시설이 청결해요"

        case "VERY_GOOD":
            result = "시설이 매우 청결해요"

        default:
            result = ""
        }
        return result
    }
    
    func costToString(cost: String) -> String {
        var result: String = ""
        switch cost {
        case "VERY_BAD":
            result = "가격이 매우 비싸요"

        case "BAD":
            result = "가격이 비싸요"

        case "NOT_BAD":
            result = "가격이 그저 그래요"

        case "GOOD":
            result = "가격이 합리적이에요"

        case "VERY_GOOD":
            result = "가격이 매우 합리적이에요"

        default:
            result = ""
        }
        return result
    }
    
    func restaurantMoodToString(mood: String) -> String {
        var result: String = ""
        switch mood {
        case "COMFORTABLE":
            result = "편안한"
        case "FORMAL":
            result = "격식 있는"
        case "HIP":
            result = "힙한"
        case "LIVELY":
            result = "활기찬"
        case "ROMANTIC":
            result = "로맨틱"
        default:
            result = ""
        }
        return result
    }
    
    func coffeeToString(coffee: String) -> String {
        var result: String = ""
        
        switch coffee{
        case "BITTER":
            result = "커피가 써요"
        case "SOUR":
            result = "커피 산미가 강해요"
        case "GENERAL":
            result = "커피가 보통이에요"
        default:
            result = ""
        }
        
        return result
    }
    
    func cafeMoodToString(mood: String) -> String {
        var result: String = ""
        switch mood {
        case "CUTE":
            result = "아기자기한"
        case "HIP":
            result = "힙한"
        case "LARGE":
            result = "크고 넓은"
        case "MODERN":
            result = "모던한"
        default:
            result = ""
        }
        return result
    }
    
    func noiseToString(noise: String) -> String {
        var result: String = ""
        switch noise {
        case "VERY_BAD":
            result = "주변이 매우 시끄러워요"
        case "BAD":
            result = "주변이 꽤 시끄러워요"
        case "NOT_BAD":
            result = "주변 소음이 그저 그래요"
        case "GOOD":
            result = "주변이 꽤 조용해요"
        case "VERY_GOOD":
            result = "주변이 매우 조용해요"
        default:
            result = ""
        }
        return result
    }
    
    func deafeningToString(deafening: String) -> String {
        var result: String = ""
        switch deafening {
        case "VERY_BAD":
            result = "방음이 전혀 안돼요"
        case "BAD":
            result = "방음이 잘 안돼요"
        case "NOT_BAD":
            result = "방음이 그저 그래요"
        case "GOOD":
            result = "방음이 잘 돼요"
        case "VERY_GOOD":
            result = "방음이 매우 잘 돼요"
        default:
            result = ""
        }
        return result
    }
    
    func parkingToString(parking: String) -> String {
        var result: String = ""
        switch parking {
        case "VERY_BAD":
            result = "주차 자리가 매우 없어요"
        case "BAD":
            result = "주차 자리가 없어요"
        case "NOT_BAD":
            result = "그냥 그래요"
        case "GOOD":
            result = "주차할 공간이 있어요"
        case "VERY_GOOD":
            result = "주차 공간이 넓어요"
        default:
            result = ""
        }
        return result
    }
    
    func waitingToString(waiting: String) -> String {
        var result: String = ""
        switch waiting {
        case "VERY_BAD":
            result = "웨이팅이 매우 길어요"
        case "BAD":
            result = "웨이팅이 길어요"
        case "NOT_BAD":
            result = "그냥 그래요"
        case "GOOD":
            result = "웨이팅이 없는 편이에요"
        case "VERY_GOOD":
            result = "바로 들어갈 수 있어요"
        default:
            result = ""
        }
        return result
    }
}

struct OpinionDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpinionDetailScreen(travelOnId: 32, opinionId: 12)
    }
}
