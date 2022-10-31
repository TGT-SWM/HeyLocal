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
            
            ScrollView {
                opinionInfo
                
                if viewModel.opinion.generalImgDownloadImgUrl.isEmpty {
                    Spacer()
                        .frame(height: 8)
                }
                
                commonOpinion
                Spacer()
                    .frame(height: 8)
                
                if (viewModel.opinion.place.category == "FD6") || (viewModel.opinion.place.category == "CE7") || (viewModel.opinion.place.category == "CT1") || (viewModel.opinion.place.category == "AT4") || (viewModel.opinion.place.category == "AD5") {
                    categoryOpinion
                    Spacer()
                        .frame(height: 8)
                }
                
                ProfileComponent(author: viewModel.opinion.author)
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
        .background(Color("lightGray"))
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
    
    var opinionInfo: some View {
        VStack(alignment: .leading) {
            // 첨부된 사진이 없다면,
            if viewModel.opinion.generalImgDownloadImgUrl.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(viewModel.opinion.place.name)")
                            .foregroundColor(.black)
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        // TODO: 수정 · 삭제 버튼
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(viewModel.opinion.place.roadAddress)")
                    }
                    .foregroundColor(Color("gray"))
                    .font(.system(size: 12))
                }
                .padding()
            }
            
            
            // 첨부된 사진이 있다면,
            else {
                ZStack(alignment: .bottomLeading) {
                    /// 이미지
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach((0..<viewModel.opinion.generalImgDownloadImgUrl.count)) { idx in
                                ZStack(alignment: .top) {
                                    AsyncImage(url: URL(string: viewModel.opinion.generalImgDownloadImgUrl[idx])) { phash in
                                        if let image = phash.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: ScreenSize.width)
                                        } else {
                                            Text("")
                                        }
                                    }
                                    
                                    Rectangle()
                                        .fill(.black)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: ScreenSize.width)
                                        .opacity(0.3)
                                    
                                    Text("\(idx + 1)/\(viewModel.opinion.generalImgDownloadImgUrl.count)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .padding()
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(viewModel.opinion.place.name)")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        
                        Spacer()
                            .frame(height: 2)
                        
                        HStack {
                            Image("location_white")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12)
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Text("\(viewModel.opinion.place.roadAddress)")
                        }
                        .font(.system(size: 12))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                    }
                    .foregroundColor(.white)
                }
                .ignoresSafeArea()
            }
        }
        .background(.white)
    }
    
    
    // MARK: - 공통 질문
    var commonOpinion: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                /// 질문
                VStack(alignment: .leading) {
                    Text("시설이 청결한가요?")
                        .font(.system(size: 14))
                    Spacer()
                        .frame(height: 32)
                    
                    Text("비용이 합리적인가요?")
                        .font(.system(size: 14))
                    Spacer()
                        .frame(height: 32)
                    
                    Text("주차장이 있나요?")
                        .font(.system(size: 14))
                    Spacer()
                        .frame(height: 32)
                    
                    Text("웨이팅이 있나요?")
                        .font(.system(size: 14))
                }
                
                Spacer()
                
                /// 별점들
                VStack(alignment: .leading) {
                    
                    /// 청결
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(viewModel.cleanArray, id:\.self) { clean in
                                if clean {
                                    Image("star_yellow")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                                else {
                                    Image("star-outline")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                            }
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Text("(\(viewModel.cleanInt)/5)")
                                .foregroundColor(Color("gray"))
                        }
                        
                        Spacer()
                            .frame(height: 2)
                        
                        Text("\(facilityToString(facility: viewModel.opinion.facilityCleanliness))")
                            .foregroundColor(Color("orange"))
                    }
                    
                    /// 비용
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(viewModel.costArray, id:\.self) { cost in
                                if cost {
                                    Image("star_yellow")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                                else {
                                    Image("star-outline")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                            }
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Text("(\(viewModel.costInt)/5)")
                                .foregroundColor(Color("gray"))
                        }
                        
                        Spacer()
                            .frame(height: 2)
                        
                        Text("\(costToString(cost: viewModel.opinion.costPerformance))")
                            .foregroundColor(Color("orange"))
                    }
                    
                    /// 주차장
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(viewModel.parkingArray, id:\.self) { park in
                                if park {
                                    Image("star_yellow")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                                else {
                                    Image("star-outline")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                            }
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Text("(\(viewModel.parkingInt)/5)")
                                .foregroundColor(Color("gray"))
                        }
                        
                        Spacer()
                            .frame(height: 2)
                        
                        Text("\(parkingToString(parking: viewModel.opinion.canParking))")
                            .foregroundColor(Color("orange"))
                    }
                    
                    /// 웨이팅
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(viewModel.waitingArray, id:\.self) { wait in
                                if wait {
                                    Image("star_yellow")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                                else {
                                    Image("star-outline")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                            }
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Text("(\(viewModel.waitingInt)/5)")
                                .foregroundColor(Color("gray"))
                        }
                        
                        Spacer()
                            .frame(height: 2)
                        
                        Text("\(waitingToString(waiting: viewModel.opinion.waiting))")
                            .foregroundColor(Color("orange"))
                    }
                }
                .font(.system(size: 12))
                .frame(width: 180)
            }
            .padding()
            

            Divider()
            
            Text("\(viewModel.opinion.description)")
                .font(.system(size: 14))
                .padding()
            
        }
        .background(.white)
    }
    
    // MARK: - 카테고리별 질문
    var categoryOpinion: some View {
        VStack(alignment: .leading) {
            Text("현지인의 꿀팁전수🍯")
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .padding()
            
            Divider()
            
            if viewModel.opinion.place.category == "FD6" {
                food
            }
            else if viewModel.opinion.place.category == "CE7" {
                cafe
            }
            else if viewModel.opinion.place.category == "CT1" || viewModel.opinion.place.category == "AT4" {
                sightseeing
            }
            else if viewModel.opinion.place.category == "AD5" {
                accommodation
            }
        }
        .background(.white)
    }
    
    // MARK: - '음식점' 답변
    var food: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text("가게 분위기는 어떤가요?")
                    .foregroundColor(Color("gray"))
                
                Spacer()
                    .frame(height: 5)
                
                Text("\(restaurantMoodToString(mood: viewModel.opinion.restaurantMoodType!))")
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("추천하는 메뉴는 무엇인가요?")
                    .foregroundColor(Color("gray"))
                
                if !viewModel.opinion.foodImgDownloadImgUrl!.isEmpty {
                    Spacer()
                        .frame(height: 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.opinion.foodImgDownloadImgUrl!, id:\.self) { url in
                                AsyncImage(url: URL(string: url)) { phash in
                                    if let image = phash.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 350, height: 350)
                                            .cornerRadius(10)
                                    }
                                    else if phash.error != nil {
                                        Text("")
                                    }
                                    else {
                                        Text("")
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 5)
                
                Text("\(viewModel.opinion.recommendFoodDescription)")
            }
            .padding()
        }
        .font(.system(size: 14))
    }
    
    // MARK: - '카페' 답변
    var cafe: some View {
        VStack(alignment: .leading){
            
            VStack(alignment: .leading) {
                Text("커피스타일이 어떤가요?")
                    .foregroundColor(Color("gray"))
                
                Spacer()
                    .frame(height: 5)
                
                Text("\(coffeeToString(coffee: viewModel.opinion.coffeeType!))")
            }
            .padding()
        
            Divider()
            
            VStack(alignment: .leading) {
                Text("추천 음료나 디저트는 무엇인가요?")
                    .foregroundColor(Color("gray"))
                
                // 사진이 있다면,
                if !viewModel.opinion.drinkAndDessertImgDownloadImgUrl!.isEmpty {
                    Spacer()
                        .frame(height: 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.opinion.drinkAndDessertImgDownloadImgUrl!, id:\.self) { url in
                                AsyncImage(url: URL(string: url)) { phash in
                                    if let image = phash.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 350, height: 350)
                                            .cornerRadius(10)
                                    }
                                    else if phash.error != nil {
                                        Text("")
                                    }
                                    else {
                                        Text("")
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 5)
                
                Text("\(viewModel.opinion.recommendDrinkAndDessertDescription)")
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("카페 분위기는 어떤가요?")
                    .foregroundColor(Color("gray"))
                
                Spacer()
                    .frame(height: 5)
                
                Text("\(cafeMoodToString(mood: viewModel.opinion.cafeMoodType!))")
            }
            .padding()
            
        }
        .font(.system(size: 14))
    }
    
    // MARK: - '문화시설' · '관광명소' 답변
    var sightseeing: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                Text("여기서 꼭 해야 하는 것이 있나요?")
                    .foregroundColor(Color("gray"))
                
                Spacer()
                    .frame(height: 5)
                
                Text("\(viewModel.opinion.recommendToDo)")
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading){
                Text("추천 간식이 있나요?")
                    .foregroundColor(Color("gray"))
                
                Spacer()
                    .frame(height: 5)
                
                Text("\(viewModel.opinion.recommendSnack)")
            }
            .padding()
            
            
            Divider()
            
            
            VStack(alignment: .leading){
                Text("이곳의 사진명소는 어디인가요?")
                    .foregroundColor(Color("gray"))
                
                if !viewModel.opinion.photoSpotImgDownloadImgUrl!.isEmpty {
                    Spacer()
                        .frame(height: 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.opinion.photoSpotImgDownloadImgUrl!, id:\.self) { url in
                                AsyncImage(url: URL(string: url)) { phash in
                                    if let image = phash.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 350, height: 350)
                                            .cornerRadius(10)
                                    }
                                    else if phash.error != nil {
                                        Text("")
                                    }
                                    else {
                                        Text("")
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 5)
                
                Text("\(viewModel.opinion.photoSpotDescription)")
            }
            .padding()
        }
        .font(.system(size: 14))
    }
    
    // MARK: - '숙박' 답변
    var accommodation: some View {
        VStack(alignment: .leading) {
            // 주변
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("주변이 시끄럽나요?")
                        .font(.system(size: 14))
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            ForEach(viewModel.noise, id:\.self) { noise in
                                if noise {
                                    Image("star_yellow")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                                else {
                                    Image("star-outline")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                            }
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Text("(\(viewModel.noiseInt)/5)")
                                .foregroundColor(Color("gray"))
                        }
                        
                        Text("\(noiseToString(noise: viewModel.opinion.streetNoise!))")
                            .foregroundColor(Color("orange"))
                    }
                    .font(.system(size: 12))
                }
            }
            
            // 방음
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("방음이 잘되나요?")
                        .font(.system(size: 14))
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            ForEach(viewModel.deafening, id:\.self) { deafening in
                                if deafening {
                                    Image("star_yellow")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                                else {
                                    Image("star-outline")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                            }
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Text("(\(viewModel.deafeningInt)/5)")
                                .foregroundColor(Color("gray"))
                        }
                        
                        Text("\(deafeningToString(deafening: viewModel.opinion.deafening!))")
                            .foregroundColor(Color("orange"))
                    }
                    .font(.system(size: 12))
                }
            }
            
            // 조식
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("조식이 나오나요?")
                        .font(.system(size: 14))
                    
                    Text(viewModel.opinion.hasBreakFast! ? "조식이 나와요" : "조식은 없어요")
                        .font(.system(size: 12))
                }
            }
        }
    }
    
    // MARK: - 5점척도 to String
    func facilityToString(facility: String) -> String {
        var result: String = ""
        switch facility {
        case "VERY_BAD":
            result = "매우 청결하지 않아요"

        case "BAD":
            result = "청결하지 않아요"

        case "NOT_BAD":
            result = "그저 그래요"

        case "GOOD":
            result = "청결한 편이에요"

        case "VERY_GOOD":
            result = "매우 청결해요"

        default:
            result = ""
        }
        return result
    }
    
    func costToString(cost: String) -> String {
        var result: String = ""
        switch cost {
        case "VERY_BAD":
            result = "매우 비싸요"

        case "BAD":
            result = "조금 비싸요"

        case "NOT_BAD":
            result = "그저 그래요"

        case "GOOD":
            result = "합리적인 편이에요"

        case "VERY_GOOD":
            result = "매우 합리적이에요"

        default:
            result = ""
        }
        return result
    }
    
    func restaurantMoodToString(mood: String) -> String {
        var result: String = ""
        switch mood {
        case "COMFORTABLE":
            result = "편안해요"
        case "FORMAL":
            result = "격식있어요"
        case "HIP":
            result = "힙해요"
        case "LIVELY":
            result = "활기차요"
        case "ROMANTIC":
            result = "로맨틱해요"
        default:
            result = ""
        }
        return result
    }
    
    func coffeeToString(coffee: String) -> String {
        var result: String = ""
        
        switch coffee{
        case "BITTER":
            result = "쓴 편이에요."
        case "SOUR":
            result = "산미가 있어요."
        case "GENERAL":
            result = "보통이에요."
        default:
            result = ""
        }
        
        return result
    }
    
    func cafeMoodToString(mood: String) -> String {
        var result: String = ""
        switch mood {
        case "CUTE":
            result = "아기자기해요."
        case "HIP":
            result = "힙해요."
        case "LARGE":
            result = "크고 넓어요."
        case "MODERN":
            result = "모던해요."
        default:
            result = ""
        }
        return result
    }
    
    func noiseToString(noise: String) -> String {
        var result: String = ""
        switch noise {
        case "VERY_BAD":
            result = "매우 시끄러워요"
        case "BAD":
            result = "조금 시끄러워요"
        case "NOT_BAD":
            result = "그저 그래요"
        case "GOOD":
            result = "조용한 편이에요"
        case "VERY_GOOD":
            result = "매우 조용해요"
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
            result = "그저 그래요"
        case "GOOD":
            result = "방음이 잘돼요"
        case "VERY_GOOD":
            result = "방음이 매우 잘돼요"
        default:
            result = ""
        }
        return result
    }
    
    func parkingToString(parking: String) -> String {
        var result: String = ""
        switch parking {
        case "VERY_BAD":
            result = "매우 협소해요"
        case "BAD":
            result = "조금 협소해요"
        case "NOT_BAD":
            result = "그저 그래요"
        case "GOOD":
            result = "넉넉한 편이에요"
        case "VERY_GOOD":
            result = "매우 넉넉해요"
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
            result = "그저 그래요"
        case "GOOD":
            result = "웨이팅이 거의 없어요"
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
