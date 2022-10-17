//
//  OpinionWriteScreen.swift
//  HeyLocal
//  답변 작성·수정 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import PhotosUI

struct OpinionWriteScreen: View {
    @State var moveBack: Bool = false
    @Environment(\.dismiss) private var dismiss
    var btnBack : some View {
        Button(action: {
            moveBack.toggle()
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .foregroundColor(.black)
        }
    }
    
    var travelOnId: Int
    @StateObject var viewModel = OpinionComponent.ViewModel()
    var writeBtn: some View {
        HStack {
            if isFill() {
                Button(action: {
                    makeJsonData()
                    if (viewModel.postOpinion(travelOnId: travelOnId, opinionData: opinionData) == 201) {
                        viewModel.fetchOpinions(travelOnId: travelOnId, opinionId: nil)
                    }
                    dismiss()
                }) {
                    Text("작성 완료")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                }
            }
            else {
                Text("작성 완료")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            }
        }
    }
    // 작성 폼을 다 채웠는지 확인하는 함수
    func isFill() -> Bool {
        var result: Bool = false
        
        if place != nil {
            if description == "" || cleanInt == 0 || waitingInt == 0 || parkingInt == 0 || costInt == 0 {
                return result
            }
            
            if place?.category == "FD6" { // 음식점
                if recommendMenu == "" || !checkArray(array: restaurantMood) {
                    return result
                }
            }
            else if place?.category == "CE7" { // 카페
                if drinkOrDessert == "" || !checkArray(array: cafeMood) || !checkArray(array: coffeeTaste) {
                    return result
                }
            }
            else if place?.category == "CT1" || place?.category == "AT4" { // 관광명소, 문화시설
                if haveToDo == "" || snack == "" || photoSpot == "" {
                    return result
                }
            }
            else if place?.category == "AD5" { // 숙박시설
                if !checkArray(array: noise) || !checkArray(array: deafening) || (yesBreakfast == noBreakfast) {
                    return result
                }
            }
            result = true
        }
        
        return result
    }
    // 배열 값 확인
    func checkArray(array: [Bool]) -> Bool {
        var result: Bool = false
        for i in 0..<array.count {
            if array[i] {
                result = true
                break
            }
        }
        return result
    }
    
    @State var opinionData = Opinion()
    func makeJsonData() {
        let LikertScale: [String] = ["VERY_BAD", "BAD", "NOT_BAD", "GOOD", "VERY_GOOD"]
        let restaurantMoodStr: [String] = ["LIVELY", "FORMAL", "ROMANTIC", "HIP", "COMFORTABLE"]
        let cafeMoodStr: [String] = ["MODERN", "LARGE", "CUTE", "HIP"]
        let coffeeTypeStr: [String] = ["BITTER", "SOUR", "GENERAL"]
        
        opinionData.place = self.place!
        opinionData.quantity?.generalImgQuantity = self.generalImages.count
        opinionData.description = self.description
        
        opinionData.facilityCleanliness = LikertScale[cleanInt - 1]
        opinionData.costPerformance = LikertScale[costInt - 1]
        opinionData.canParking = LikertScale[parkingInt - 1]
        opinionData.waiting = LikertScale[waitingInt - 1]
        
        // 음식점
        if self.place!.category == "FD6" {
            for i in 0..<5 {
                if restaurantMood[i] == true {
                    opinionData.restaurantMoodType = restaurantMoodStr[i]
                    break
                }
            }
            opinionData.recommendFoodDescription = self.recommendMenu
            opinionData.quantity?.foodImgQuantity = self.foodImages.count
        }
        
        // 카페
        else if self.place!.category == "CE7" {
            for i in 0..<3 {
                if coffeeTaste[i] == true {
                    opinionData.coffeeType = coffeeTypeStr[i]
                    break
                }
            }
            for i in 0..<4 {
                if cafeMood[i] == true {
                    opinionData.cafeMoodType = cafeMoodStr[i]
                    break
                }
            }
            opinionData.recommendDrinkAndDessertDescription = self.drinkOrDessert
            opinionData.quantity?.drinkAndDessertImgQuantity = self.cafeImages.count
        }
        
        // 숙박시설
        else if self.place!.category == "AD5" {
            for i in 0..<5 {
                if noise[i] == true {
                    opinionData.streetNoise = LikertScale[i]
                }
                
                if deafening[i] == true {
                    opinionData.deafening = LikertScale[i]
                }
            }
            opinionData.hasBreakFast = self.yesBreakfast
        }
        
        // 문화시설, 관광명소
        else if self.place!.category == "CT1" ||  self.place!.category == "AT4" {
            opinionData.recommendToDo = self.haveToDo
            opinionData.recommendSnack = self.snack
            opinionData.photoSpotDescription = self.photoSpot
            opinionData.quantity?.photoSpotImgQuantity = self.photoSpotImages.count
        }
    }
    
    
    // MARK: - body
    @State private var image: UIImage? = nil
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                content
                
                // 질문 항목
                Group {
                    common
                    
                    if place != nil {
                        switch place!.category{
                        case "CE7":
                            cafe
                            
                        case "CT1":
                            sightseeing
                            
                        case "AT4":
                            sightseeing
                            
                        case "FD6":
                            restaurant
                            
                        case "AD5":
                            accommodation
                            
                        default:
                            Text("")
                        }
                    }
                }.padding()
            }
            
            if moveBack {
                CustomAlert(showingAlert: $moveBack,
                            title: "답변 작성을 취소할까요?",
                            cancelMessage: "아니요,작성할래요",
                            confirmMessage: "네,취소할래요",
                            cancelWidth: 134,
                            confirmWidth: 109,
                            rightButtonAction: {dismiss()})
            }
        }
        .navigationTitle("답변 작성")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: writeBtn)
    }
    
    
    // MARK: - 장소 선택, 사진, 설명
    @State var showImagePicker: Bool = false
    @State var tmpImg: UIImage?
    @State var isPhotoPicker: Bool = false
    
    
    // MARK: - 공통·필수 질문 변수 · View
    @State var place: Place? = nil
    @State var description: String = ""
    @State var generalImages: [UIImage] = [UIImage]()
    var content: some View {
        VStack(alignment: .leading) {
            // 장소 -> NavigationLink 장소 선택
            NavigationLink(destination: OpinionPlacePickerScreen(place: $place)) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .frame(width: 350, height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .cornerRadius(10)


                    HStack {
                        if place == nil {
                            Text("  장소 검색")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        }
                        else {
                            Text("\(place!.name)")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        }
                        
                        Spacer()

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(red: 110 / 255, green: 108 / 255, blue: 106 / 255))
                            .padding()
                    }
                }
            }

            // 사진 추가
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
//                    List {
//                        ForEach(generalImages, id:\.self) { image in
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 100)
//                        }
//                    }
//                    Text("\(generalImages.count)")
                    
                    if tmpImg != nil {
                        Image(uiImage: tmpImg!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
    
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.white)
//                                .frame(width: 100, height: 100)
//                                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
//                                .cornerRadius(10)
//
//                            ZStack {
//                                Circle()
//                                    .fill(Color(red: 255/255, green: 153/255, blue: 0/255))
//                                    .frame(width: 24, height: 24)
//
//                                Image(systemName: "plus")
//                                    .foregroundColor(Color.white)
//                            }
//                        }
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                                .cornerRadius(10)
                            
                            
                            VStack(alignment: .center) {
                                Image(systemName: "camera")
                                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                                
                                Text("\(generalImages.count) / 3")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                            }
                            
                                
                        }
                    }
                    .sheet(isPresented: $showImagePicker){
                        ImagePickerView(sourceType: .photoLibrary) { image in
                            self.tmpImg = image
                        }
                    }
                    
//                    Button(action: { showImagePicker = true }) {
//                        Label("Choose Photos", systemImage: "photo.fill")
//                    }
//                    .fullScreenCover(isPresented: $showImagePicker) {
//                        PhotoPicker(filter: .images, limit: 3) { results in
//                            PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
//                                if let error = errorOrNil {
//                                    print(error)
//                                }
//
//                                if let images = imagesOrNil {
//                                    if let first = images.first {
//                                        print(first)
//                                        image = first
//                                    }
//                                }
//                            }
//
//                        }
//                    }
//
//                    if let image = image {
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100, height: 100)
//                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("장소와 무관한 사진을 첨부하면, 게시 제한 처리될 수 있습니다.")
                Text("사진 첨부 시 개인정보가 노출되지 않도록 유의해주세요.")
            }
            .font(.system(size: 12))
            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            // 설명
            ZStack(alignment: .topLeading) {
                TextField("", text: $description)
                    .multilineTextAlignment(TextAlignment.leading)
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    .frame(width: 350, height: 80)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                    .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                    .cornerRadius(10)
                
                if description == "" {
                    VStack(alignment: .leading) {
                        Text("한줄평을 작성해주세요!")
                    }
                    .padding()
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                }
            }
        }
        .padding()
    }
    
    
    
    // MARK: - 공통 질문
    @State var cleanInt: Int = 0
    @State var parkingInt: Int = 0
    @State var waitingInt: Int = 0
    @State var costInt: Int = 0
    @State var clean: [Bool] = [false, false, false, false, false]
    @State var cost: [Bool] = [false, false, false, false, false]
    @State var parking: [Bool] = [false, false, false, false, false]
    @State var waiting: [Bool] = [false, false, false, false, false]
    var common: some View {
        VStack(alignment: .leading){
            Group {
                Divider()
                
                Group {
                    Text("시설이 청결한가요?")
                    
                    HStack {
                        Button(action: {
                            cleanInt = 1
                            for i in 0..<5 {
                                clean[i] = false
                            }
                            for i in 0..<cleanInt {
                                clean[i] = true
                            }
                        }) {
                            Image(clean[0] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            cleanInt = 2
                            for i in 0..<5 {
                                clean[i] = false
                            }
                            for i in 0..<cleanInt {
                                clean[i] = true
                            }
                        }) {
                            Image(clean[1] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            cleanInt = 3
                            for i in 0..<5 {
                                clean[i] = false
                            }
                            for i in 0..<cleanInt {
                                clean[i] = true
                            }
                        }) {
                            Image(clean[2] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            cleanInt = 4
                            for i in 0..<5 {
                                clean[i] = false
                            }
                            for i in 0..<cleanInt {
                                clean[i] = true
                            }
                        }) {
                            Image(clean[3] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            cleanInt = 5
                            for i in 0..<5 {
                                clean[i] = false
                            }
                            for i in 0..<cleanInt {
                                clean[i] = true
                            }
                        }) {
                            Image(clean[4] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("(\(cleanInt)/5)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0))
                }
                
                Group {
                    Text("비용이 합리적인가요?")
                    
                    HStack {
                        Button(action: {
                            costInt = 1
                            for i in 0..<5 {
                                cost[i] = false
                            }
                            for i in 0..<costInt {
                                cost[i] = true
                            }
                        }) {
                            Image(cost[0] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            costInt = 2
                            for i in 0..<5 {
                                cost[i] = false
                            }
                            for i in 0..<costInt {
                                cost[i] = true
                            }
                        }) {
                            Image(cost[1] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            costInt = 3
                            for i in 0..<5 {
                                cost[i] = false
                            }
                            for i in 0..<costInt {
                                cost[i] = true
                            }
                        }) {
                            Image(cost[2] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            costInt = 4
                            for i in 0..<5 {
                                cost[i] = false
                            }
                            for i in 0..<costInt {
                                cost[i] = true
                            }
                        }) {
                            Image(cost[3] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            costInt = 5
                            for i in 0..<5 {
                                cost[i] = false
                            }
                            for i in 0..<costInt {
                                cost[i] = true
                            }
                        }) {
                            Image(cost[4] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("(\(costInt)/5)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0))
                }
                
                
                Group {
                    Text("주차 공간이 충분한가요?")
                    
                    HStack {
                        Button(action: {
                            parkingInt = 1
                            for i in 0..<5 {
                                parking[i] = false
                            }
                            for i in 0..<parkingInt {
                                parking[i] = true
                            }
                        }) {
                            Image(parking[0] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            parkingInt = 2
                            for i in 0..<5 {
                                parking[i] = false
                            }
                            for i in 0..<parkingInt {
                                parking[i] = true
                            }
                        }) {
                            Image(parking[1] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            parkingInt = 3
                            for i in 0..<5 {
                                parking[i] = false
                            }
                            for i in 0..<parkingInt {
                                parking[i] = true
                            }
                        }) {
                            Image(parking[2] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            parkingInt = 4
                            for i in 0..<5 {
                                parking[i] = false
                            }
                            for i in 0..<parkingInt {
                                parking[i] = true
                            }
                        }) {
                            Image(parking[3] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            parkingInt = 5
                            for i in 0..<5 {
                                parking[i] = false
                            }
                            for i in 0..<parkingInt {
                                parking[i] = true
                            }
                        }) {
                            Image(parking[4] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("(\(parkingInt)/5)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0))
                }
                
                Group {
                    Text("웨이팅")
                    
                    HStack {
                        Button(action: {
                            waitingInt = 1
                            for i in 0..<5 {
                                waiting[i] = false
                            }
                            for i in 0..<waitingInt {
                                waiting[i] = true
                            }
                        }) {
                            Image(waiting[0] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            waitingInt = 2
                            for i in 0..<5 {
                                waiting[i] = false
                            }
                            for i in 0..<waitingInt {
                                waiting[i] = true
                            }
                        }) {
                            Image(waiting[1] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            waitingInt = 3
                            for i in 0..<5 {
                                waiting[i] = false
                            }
                            for i in 0..<waitingInt {
                                waiting[i] = true
                            }
                        }) {
                            Image(waiting[2] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            waitingInt = 4
                            for i in 0..<5 {
                                waiting[i] = false
                            }
                            for i in 0..<waitingInt {
                                waiting[i] = true
                            }
                        }) {
                            Image(waiting[3] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            waitingInt = 5
                            for i in 0..<5 {
                                waiting[i] = false
                            }
                            for i in 0..<waitingInt {
                                waiting[i] = true
                            }
                        }) {
                            Image(waiting[4] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("(\(waitingInt)/5)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0))
                }
            }
            .font(.system(size: 14))
        }
    }
    
    // MARK: - 음식점  변수 · View
    @State var restaurantMood: [Bool] = [false, false, false, false, false]     // LIVELY, FORMAL, ROMANTIC, HIP, COMFORTABLE
    @State var recommendMenu: String = ""
    @State var foodImages: [UIImage] = [UIImage]()
    var restaurant: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            Group {
                Text("가게 분위기가 어떤가요?")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            for i in 1 ..< restaurantMood.count {
                                if restaurantMood[i] == true {
                                    restaurantMood[i] = false
                                }
                            }
                            restaurantMood[0].toggle()
                        }) {
                            Text("활기찬")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $restaurantMood[0], width: 66))
                        
                        Button(action: {
                            for i in 0 ..< restaurantMood.count {
                                if i == 1 {
                                    continue
                                }
                                if restaurantMood[i] == true {
                                    restaurantMood[i] = false
                                }
                            }
                            restaurantMood[1].toggle()
                        }) {
                            Text("격식있는")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $restaurantMood[1], width: 78))
                        
                        Button(action: {
                            for i in 0 ..< restaurantMood.count {
                                if i == 2 {
                                    continue
                                }
                                if restaurantMood[i] == true {
                                    restaurantMood[i] = false
                                }
                            }
                            restaurantMood[2].toggle()
                        }) {
                            Text("로맨틱")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $restaurantMood[2], width: 66))
                        
                        Button(action: {
                            for i in 0 ..< restaurantMood.count {
                                if i == 3 {
                                    continue
                                }
                                if restaurantMood[i] == true {
                                    restaurantMood[i] = false
                                }
                            }
                            restaurantMood[3].toggle()
                        }) {
                            Text("힙한")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $restaurantMood[3], width: 54))
                        
                        Button(action: {
                            for i in 0 ..< (cost.count - 1) {
                                if restaurantMood[i] == true {
                                    restaurantMood[i] = false
                                }
                            }
                            restaurantMood[4].toggle()
                        }) {
                            Text("편안한")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $restaurantMood[4], width: 66))
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
            }
            .font(.system(size: 14))
            
            Group {
                Text("추천하는 메뉴는 무엇인가요?")
                    .font(.system(size: 14))
                
                // Image
                Button(action: {}){
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                            .cornerRadius(10)
                        
                        
                        VStack(alignment: .center) {
                            Image(systemName: "camera")
                                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                            
                            Text("\(generalImages.count) / 3")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        }
                    }
                }
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $recommendMenu)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if recommendMenu == "" {
                        VStack(alignment: .leading) {
                            Text("25자 이내로 작성해주세요")
                        }
                        .padding()
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        } // vstack
    } // restaurant
    
    
    // MARK: - 카페  변수 · View
    @State var drinkOrDessert: String = ""
    @State var cafeMood: [Bool] = [false, false, false, false]      // MODERN, LARGE, CUTE, HIP
    @State var coffeeTaste: [Bool] = [false, false, false]          // BITTER, SOUR, GENERAL
    @State var cafeImages: [UIImage] = [UIImage]()
    var cafe: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            // 커피 맛
            Group {
                Text("커피 맛이 어떤가요?")
                
                HStack {
                    Button(action: {
                        for i in 1 ..< coffeeTaste.count {
                            if coffeeTaste[i] == true {
                                coffeeTaste[i] = false
                            }
                        }
                        coffeeTaste[0].toggle()
                    }) {
                        Text("쓴맛")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $coffeeTaste[0], width: 66))
                    
                    Button(action: {
                        for i in 0 ..< coffeeTaste.count {
                            if i == 1 {
                                continue
                            }
                            if coffeeTaste[i] == true {
                                coffeeTaste[i] = false
                            }
                        }
                        coffeeTaste[1].toggle()
                    }) {
                        Text("산미가 강한")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $coffeeTaste[1], width: 93))
                    
                    Button(action: {
                        for i in 0 ..< coffeeTaste.count {
                            if i == 2 {
                                continue
                            }
                            if coffeeTaste[i] == true {
                                coffeeTaste[i] = false
                            }
                        }
                        coffeeTaste[2].toggle()
                    }) {
                        Text("보통")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $coffeeTaste[2], width: 54))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
            .font(.system(size: 14))
            
            // 카페 분위기
            Group {
                Text("카페 분위기가 어떤가요?")
                
                HStack {
                    Button(action: {
                        for i in 1 ..< cafeMood.count {
                            if cafeMood[i] == true {
                                cafeMood[i] = false
                            }
                        }
                        cafeMood[0].toggle()
                    }) {
                        Text("모던한")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $cafeMood[0], width: 66))
                    
                    Button(action: {
                        for i in 0 ..< cafeMood.count {
                            if i == 1 {
                                continue
                            }
                            if cafeMood[i] == true {
                                cafeMood[i] = false
                            }
                        }
                        cafeMood[1].toggle()
                    }) {
                        Text("크고 넓은")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $cafeMood[1], width: 81))
                    
                    Button(action: {
                        for i in 0 ..< cafeMood.count {
                            if i == 2 {
                                continue
                            }
                            if cafeMood[i] == true {
                                cafeMood[i] = false
                            }
                        }
                        cafeMood[2].toggle()
                    }) {
                        Text("아기자기한")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $cafeMood[2], width: 91))
                    
                    Button(action: {
                        for i in 0 ..< cafeMood.count {
                            if i == 3 {
                                continue
                            }
                            if cafeMood[i] == true {
                                cafeMood[i] = false
                            }
                        }
                        cafeMood[3].toggle()
                    }) {
                        Text("힙한")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $cafeMood[3], width: 54))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
            .font(.system(size: 14))
            
            Group {
                Text("이곳의 추천 음료·디저트는 무엇인가요?")
                    .font(.system(size: 14))
                
                // Image
                Button(action: {}){
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 50, height: 50)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                            .cornerRadius(10)
                        
                        ZStack {
                            Circle()
                                .fill(Color(red: 255/255, green: 153/255, blue: 0/255))
                                .frame(width: 16, height: 16)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 9)
                                .foregroundColor(Color.white)
                                
                        }
                    }
                }
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $drinkOrDessert)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if drinkOrDessert == "" {
                        VStack(alignment: .leading) {
                            Text("25자 이내로 작성해주세요")
                        }
                        .padding()
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }
    }
    
    // MARK: - 관광명소 및 문화시설  변수 · View
    @State var haveToDo: String = ""
    @State var snack: String = ""
    @State var photoSpot: String = ""
    @State var photoSpotImages: [UIImage] = [UIImage]()
    var sightseeing: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            Group {
                Text("여기서 꼭 해봐야 하는 게 있나요?")
                    .font(.system(size: 14))
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $haveToDo)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if haveToDo == "" {
                        VStack(alignment: .leading) {
                            Text("25자 이내로 작성해주세요")
                        }
                        .padding()
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
            
            Group {
                Text("추천 간식이 있나요?")
                    .font(.system(size: 14))
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $snack)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if snack == "" {
                        VStack(alignment: .leading) {
                            Text("25자 이내로 작성해주세요")
                        }
                        .padding()
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
            
            Group {
                Text("이곳의 사진 명소는 어디인가요?")
                    .font(.system(size: 14))
                
                // Image
                Button(action: {}){
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 50, height: 50)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                            .cornerRadius(10)
                        
                        ZStack {
                            Circle()
                                .fill(Color(red: 255/255, green: 153/255, blue: 0/255))
                                .frame(width: 16, height: 16)
                            
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 9)
                                .foregroundColor(Color.white)
                                
                        }
                    }
                }
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $photoSpot)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if photoSpot == "" {
                        VStack(alignment: .leading) {
                            Text("25자 이내로 작성해주세요")
                        }
                        .padding()
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }
    }
    
    // MARK: - 숙박시설 변수 · View
    @State var noise: [Bool] = [false, false, false, false, false]
    @State var deafening: [Bool] = [false, false, false, false, false]
    @State var yesBreakfast: Bool = false
    @State var noBreakfast: Bool = false
    var accommodation: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Group {
                Text("주변이 시끄럽나요?")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            for i in 1 ..< noise.count {
                                if noise[i] == true {
                                    noise[i] = false
                                }
                            }
                            noise[0].toggle()
                        }) {
                            Text("매우 시끄러워요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noise[0], width: 117))
                        
                        Button(action: {
                            for i in 0 ..< noise.count {
                                if i == 1 {
                                    continue
                                }
                                if noise[i] == true {
                                    noise[i] = false
                                }
                            }
                            noise[1].toggle()
                        }) {
                            Text("시끄러워요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noise[1], width: 93))
                        
                        Button(action: {
                            for i in 0 ..< noise.count {
                                if i == 2 {
                                    continue
                                }
                                if noise[i] == true {
                                    noise[i] = false
                                }
                            }
                            noise[2].toggle()
                        }) {
                            Text("그냥 그래요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noise[2], width: 93))
                        
                        Button(action: {
                            for i in 0 ..< noise.count {
                                if i == 3 {
                                    continue
                                }
                                if noise[i] == true {
                                    noise[i] = false
                                }
                            }
                            noise[3].toggle()
                        }) {
                            Text("괜찮아요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noise[3], width: 78))
                        
                        Button(action: {
                            for i in 0 ..< (cost.count - 1) {
                                if noise[i] == true {
                                    noise[i] = false
                                }
                            }
                            noise[4].toggle()
                        }) {
                            Text("조용해요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noise[4], width: 78))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
            .font(.system(size: 14))
            
            Group {
                Text("방음이 잘 되나요?")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            for i in 1 ..< deafening.count {
                                if deafening[i] == true {
                                    deafening[i] = false
                                }
                            }
                            deafening[0].toggle()
                        }) {
                            Text("전혀 안돼요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $deafening[0], width: 100))
                        
                        Button(action: {
                            for i in 0 ..< deafening.count {
                                if i == 1 {
                                    continue
                                }
                                if deafening[i] == true {
                                    deafening[i] = false
                                }
                            }
                            deafening[1].toggle()
                        }) {
                            Text("잘 안돼요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $deafening[1], width: 93))
                        
                        Button(action: {
                            for i in 0 ..< deafening.count {
                                if i == 2 {
                                    continue
                                }
                                if deafening[i] == true {
                                    deafening[i] = false
                                }
                            }
                            deafening[2].toggle()
                        }) {
                            Text("그냥 그래요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $deafening[2], width: 93))
                        
                        Button(action: {
                            for i in 0 ..< deafening.count {
                                if i == 3 {
                                    continue
                                }
                                if deafening[i] == true {
                                    deafening[i] = false
                                }
                            }
                            deafening[3].toggle()
                        }) {
                            Text("잘 돼요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $deafening[3], width: 66))
                        
                        Button(action: {
                            for i in 0 ..< (deafening.count - 1) {
                                if deafening[i] == true {
                                    deafening[i] = false
                                }
                            }
                            deafening[4].toggle()
                        }) {
                            Text("매우 잘 돼요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $deafening[4], width: 93))
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
            }
            .font(.system(size: 14))
            
            Group {
                Text("조식이 나오나요?")
                
                HStack {
                    Button(action: {
                        if noBreakfast {
                            noBreakfast = false
                        }
                        yesBreakfast.toggle()
                    }) {
                        Text("나와요")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $yesBreakfast, width: 66))
                    
                    Button(action: {
                        if yesBreakfast {
                            yesBreakfast = false
                        }
                        noBreakfast.toggle()
                    }) {
                        Text("안나와요")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $noBreakfast, width: 78))
                }
            }
            .font(.system(size: 14))
        }
    } // acco
}


// MARK: - Photo Picker
//struct PhotoPicker: UIViewControllerRepresentable {
//    @Binding var pickerResult: [UIImage] // pass images back to the SwiftUI view
//    @Binding var isPresented: Bool // close the modal view
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
//        configuration.filter = .images // filter only to images
//        configuration.selectionLimit = 0 // ignore limit
//
//        let photoPickerViewController = PHPickerViewController(configuration: configuration)
//        photoPickerViewController.delegate = context.coordinator // Use Coordinator for delegation
//        return photoPickerViewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    // Create the Coordinator, in this case it is a way to communicate with the PHPickerViewController
//    class Coordinator: PHPickerViewControllerDelegate {
//        private let parent: PhotoPicker
//
//        init(_ parent: PhotoPicker) {
//            self.parent = parent
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.pickerResult.removeAll()
//
//            for image in results {
//                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
//                        if let error = error {
//                            print("Can't load image \(error.localizedDescription)")
//                        } else if let image = newImage as? UIImage {
//                            self?.parent.pickerResult.append(image)
//                        }
//                    }
//                }
//                else {
//                    print("Can't load asset")
//                }
//            }
//
//            parent.isPresented = false
//        }
//    }
//}

// MARK: - PhotoPicker 2
struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    let filter: PHPickerFilter
    var limit: Int = 0
    let onComplete: ([PHPickerResult]) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = limit
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.onComplete(results)
            picker.dismiss(animated: true)
        }
    }
    
    static func convertToUIImageArray(fromResults results: [PHPickerResult], onComplete: @escaping ([UIImage]?, Error?) -> Void) {
        var images = [UIImage]()
        let dispatchGroup = DispatchGroup()
        for result in results {
            dispatchGroup.enter()
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (imageOrNil, errorOrNil) in
                    if let error = errorOrNil {
                        onComplete(nil, error)
                    }
                    if let image = imageOrNil as? UIImage {
                        images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            onComplete(images, nil)
        }
    }
}


struct OpinionWriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpinionWriteScreen(travelOnId: 12)
    }
}
