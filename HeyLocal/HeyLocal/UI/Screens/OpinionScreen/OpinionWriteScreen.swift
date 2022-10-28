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
    
    // 수정하기에서 넘어왔다면, opinionId를 받아와
    var opinionId: Int?
    var travelOnId: Int
    @StateObject var viewModel = OpinionComponent.ViewModel()
    var writeBtn: some View {
        HStack {
            if isFill() {
                if opinionId == nil {
                    Button(action: {
                        makeJsonData()
                        if (viewModel.postOpinion(travelOnId: travelOnId, opinionData: opinionData, generalImages: generalImages, foodImages: foodImages, cafeImages: cafeImages, photoSpotImages: photoSpotImages) == 201) {
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
                    Button(action: {
                        makeJsonData()
                        viewModel.updateOpinion(travelOnId: travelOnId, opinionId: opinionId!, opinionData: opinionData)
                        dismiss()
                    }) {
                        Text("수정 완료")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    }
                }
            }
            else {
                if opinionId == nil {
                    Text("작성 완료")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                }
                else {
                    Text("수정 완료")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                }
            }
        }
    }
    // 작성 폼을 다 채웠는지 확인하는 함수
    func isFill() -> Bool {
        var result: Bool = false
        
        if viewModel.opinion.place.name != "" {
            if viewModel.opinion.description == "" || viewModel.cleanInt == 0 || viewModel.waitingInt == 0 || viewModel.parkingInt == 0 || viewModel.costInt == 0 {
                return result
            }
            
            if viewModel.opinion.place.category == "FD6" { // 음식점
                if viewModel.opinion.recommendFoodDescription == "" || !checkArray(array: viewModel.restaurantMood) {
                    return result
                }
            }
            else if viewModel.opinion.place.category == "CE7" { // 카페
                if viewModel.opinion.recommendDrinkAndDessertDescription == "" || !checkArray(array: viewModel.cafeMood) || !checkArray(array: viewModel.coffee) {
                    return result
                }
            }
            else if viewModel.opinion.place.category == "CT1" || viewModel.opinion.place.category == "AT4" { // 관광명소, 문화시설
                if viewModel.opinion.recommendToDo == "" || viewModel.opinion.recommendSnack == "" || viewModel.opinion.photoSpotDescription == "" {
                    return result
                }
            }
            else if viewModel.opinion.place.category == "AD5" { // 숙박시설
                if !checkArray(array: viewModel.noise) || !checkArray(array: viewModel.deafening) || (yesBreakfast == noBreakfast) {
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
        
        opinionData.place = viewModel.opinion.place
        opinionData.quantity?.generalImgQuantity = self.generalImages.count
        opinionData.description = viewModel.opinion.description
        
        opinionData.facilityCleanliness = LikertScale[viewModel.cleanInt - 1]
        opinionData.costPerformance = LikertScale[viewModel.costInt - 1]
        opinionData.canParking = LikertScale[viewModel.parkingInt - 1]
        opinionData.waiting = LikertScale[viewModel.waitingInt - 1]
        
        // 음식점
        if viewModel.opinion.place.category == "FD6" {
            for i in 0..<5 {
                if viewModel.restaurantMood[i] == true {
                    opinionData.restaurantMoodType = restaurantMoodStr[i]
                    break
                }
            }
            opinionData.recommendFoodDescription = viewModel.opinion.recommendFoodDescription
            opinionData.quantity?.foodImgQuantity = self.foodImages.count
        }
        
        // 카페
        else if viewModel.opinion.place.category == "CE7" {
            for i in 0..<3 {
                if viewModel.coffee[i] == true {
                    opinionData.coffeeType = coffeeTypeStr[i]
                    break
                }
            }
            for i in 0..<4 {
                if viewModel.cafeMood[i] == true {
                    opinionData.cafeMoodType = cafeMoodStr[i]
                    break
                }
            }
            opinionData.recommendDrinkAndDessertDescription = viewModel.opinion.recommendDrinkAndDessertDescription
            opinionData.quantity?.drinkAndDessertImgQuantity = self.cafeImages.count
        }
        
        // 숙박시설
        else if viewModel.opinion.place.category == "AD5" {
            for i in 0..<5 {
                if viewModel.noise[i] == true {
                    opinionData.streetNoise = LikertScale[i]
                }
                
                if viewModel.deafening[i] == true {
                    opinionData.deafening = LikertScale[i]
                }
            }
            opinionData.hasBreakFast = self.yesBreakfast
        }
        
        // 문화시설, 관광명소
        else if viewModel.opinion.place.category == "CT1" ||  viewModel.opinion.place.category == "AT4" {
            opinionData.recommendToDo = viewModel.opinion.recommendToDo
            opinionData.recommendSnack = viewModel.opinion.recommendSnack
            opinionData.photoSpotDescription = viewModel.opinion.photoSpotDescription
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
                    
                    if viewModel.opinion.place.name != "" {
                        switch viewModel.opinion.place.category{
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
        .onAppear {
            if opinionId != nil {
                viewModel.fetchOpinions(travelOnId: travelOnId, opinionId: opinionId!)
            }
        }
        .navigationTitle("답변 작성")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: writeBtn)
    }

    // MARK: - 공통·필수 질문 변수 · View
    @State var showGeneralImagePicker: Bool = false
    @State var generalImages: [SelectedImage] = []
    var content: some View {
        VStack(alignment: .leading) {
            // 장소 -> NavigationLink 장소 선택
            NavigationLink(destination: OpinionPlacePickerScreen(place: $viewModel.opinion.place)) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .frame(width: 350, height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .cornerRadius(10)


                    HStack {
                        if viewModel.opinion.place.name == "" {
                            Text("  장소 검색")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        }
                        else {
                            Text("\(viewModel.opinion.place.name)")
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
                ZStack {
                    HStack {
                        // 이미지 추가 버튼
                        Button(action: {
                            if generalImages.count < 3 {
                                showGeneralImagePicker.toggle()
                            }
                        }) {
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
                        
                        // 이미지 View
                        ForEach(generalImages, id:\.self) { img in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: img.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                
                                // 이미지 삭제버튼
                                Button(action: {
                                    if let index = generalImages.firstIndex(of: img) {
                                        generalImages.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "multiply")
                                        .resizable()
                                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                    }
                    
                    if self.showGeneralImagePicker {
                        NavigationLink("", destination: CustomImagePicker(selectedImages: self.$generalImages, showingPicker: self.$showGeneralImagePicker), isActive: $showGeneralImagePicker)
                    }
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
                TextField("", text: $viewModel.opinion.description)
                    .multilineTextAlignment(TextAlignment.leading)
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    .frame(width: 350, height: 80)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                    .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                    .cornerRadius(10)
                
                if viewModel.opinion.description == "" {
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
    var common: some View {
        VStack(alignment: .leading){
            Group {
                Divider()
                
                Group {
                    Text("시설이 청결한가요?")
                    
                    HStack {
                        Button(action: {
                            viewModel.cleanInt = 1
                            for i in 0..<5 {
                                viewModel.cleanArray[i] = false
                            }
                            for i in 0..<viewModel.cleanInt {
                                viewModel.cleanArray[i] = true
                            }
                        }) {
                            Image(viewModel.cleanArray[0] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.cleanInt = 2
                            for i in 0..<5 {
                                viewModel.cleanArray[i] = false
                            }
                            for i in 0..<viewModel.cleanInt {
                                viewModel.cleanArray[i] = true
                            }
                        }) {
                            Image(viewModel.cleanArray[1] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.cleanInt = 3
                            for i in 0..<5 {
                                viewModel.cleanArray[i] = false
                            }
                            for i in 0..<viewModel.cleanInt {
                                viewModel.cleanArray[i] = true
                            }
                        }) {
                            Image(viewModel.cleanArray[2] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.cleanInt = 4
                            for i in 0..<5 {
                                viewModel.cleanArray[i] = false
                            }
                            for i in 0..<viewModel.cleanInt {
                                viewModel.cleanArray[i] = true
                            }
                        }) {
                            Image(viewModel.cleanArray[3] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.cleanInt = 5
                            for i in 0..<5 {
                                viewModel.cleanArray[i] = false
                            }
                            for i in 0..<viewModel.cleanInt {
                                viewModel.cleanArray[i] = true
                            }
                        }) {
                            Image(viewModel.cleanArray[4] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("(\(viewModel.cleanInt)/5)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0))
                }
                
                Group {
                    Text("비용이 합리적인가요?")
                    
                    HStack {
                        Button(action: {
                            viewModel.costInt = 1
                            for i in 0..<5 {
                                viewModel.costArray[i] = false
                            }
                            for i in 0..<viewModel.costInt {
                                viewModel.costArray[i] = true
                            }
                        }) {
                            Image(viewModel.costArray[0] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.costInt = 2
                            for i in 0..<5 {
                                viewModel.costArray[i] = false
                            }
                            for i in 0..<viewModel.costInt {
                                viewModel.costArray[i] = true
                            }
                        }) {
                            Image(viewModel.costArray[1] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.costInt = 3
                            for i in 0..<5 {
                                viewModel.costArray[i] = false
                            }
                            for i in 0..<viewModel.costInt {
                                viewModel.costArray[i] = true
                            }
                        }) {
                            Image(viewModel.costArray[2] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.costInt = 4
                            for i in 0..<5 {
                                viewModel.costArray[i] = false
                            }
                            for i in 0..<viewModel.costInt {
                                viewModel.costArray[i] = true
                            }
                        }) {
                            Image(viewModel.costArray[3] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.costInt = 5
                            for i in 0..<5 {
                                viewModel.costArray[i] = false
                            }
                            for i in 0..<viewModel.costInt {
                                viewModel.costArray[i] = true
                            }
                        }) {
                            Image(viewModel.costArray[4] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("(\(viewModel.costInt)/5)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0))
                }
                
                
                Group {
                    Text("주차 공간이 충분한가요?")
                    
                    HStack {
                        Button(action: {
                            viewModel.parkingInt = 1
                            for i in 0..<5 {
                                viewModel.parkingArray[i] = false
                            }
                            for i in 0..<viewModel.parkingInt {
                                viewModel.parkingArray[i] = true
                            }
                        }) {
                            Image(viewModel.parkingArray[0] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.parkingInt = 2
                            for i in 0..<5 {
                                viewModel.parkingArray[i] = false
                            }
                            for i in 0..<viewModel.parkingInt {
                                viewModel.parkingArray[i] = true
                            }
                        }) {
                            Image(viewModel.parkingArray[1] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.parkingInt = 3
                            for i in 0..<5 {
                                viewModel.parkingArray[i] = false
                            }
                            for i in 0..<viewModel.parkingInt {
                                viewModel.parkingArray[i] = true
                            }
                        }) {
                            Image(viewModel.parkingArray[2] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.parkingInt = 4
                            for i in 0..<5 {
                                viewModel.parkingArray[i] = false
                            }
                            for i in 0..<viewModel.parkingInt {
                                viewModel.parkingArray[i] = true
                            }
                        }) {
                            Image(viewModel.parkingArray[3] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.parkingInt = 5
                            for i in 0..<5 {
                                viewModel.parkingArray[i] = false
                            }
                            for i in 0..<viewModel.parkingInt {
                                viewModel.parkingArray[i] = true
                            }
                        }) {
                            Image(viewModel.parkingArray[4] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("(\(viewModel.parkingInt)/5)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0))
                }
                
                Group {
                    Text("웨이팅은 어떤가요?")
                    
                    HStack {
                        Button(action: {
                            viewModel.waitingInt = 1
                            for i in 0..<5 {
                                viewModel.waitingArray[i] = false
                            }
                            for i in 0..<viewModel.waitingInt {
                                viewModel.waitingArray[i] = true
                            }
                        }) {
                            Image(viewModel.waitingArray[0] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.waitingInt = 2
                            for i in 0..<5 {
                                viewModel.waitingArray[i] = false
                            }
                            for i in 0..<viewModel.waitingInt {
                                viewModel.waitingArray[i] = true
                            }
                        }) {
                            Image(viewModel.waitingArray[1] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.waitingInt = 3
                            for i in 0..<5 {
                                viewModel.waitingArray[i] = false
                            }
                            for i in 0..<viewModel.waitingInt {
                                viewModel.waitingArray[i] = true
                            }
                        }) {
                            Image(viewModel.waitingArray[2] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.waitingInt = 4
                            for i in 0..<5 {
                                viewModel.waitingArray[i] = false
                            }
                            for i in 0..<viewModel.waitingInt {
                                viewModel.waitingArray[i] = true
                            }
                        }) {
                            Image(viewModel.waitingArray[3] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            viewModel.waitingInt = 5
                            for i in 0..<5 {
                                viewModel.waitingArray[i] = false
                            }
                            for i in 0..<viewModel.waitingInt {
                                viewModel.waitingArray[i] = true
                            }
                        }) {
                            Image(viewModel.waitingArray[4] ? "star_fill_icon" : "star_icon")
                                .resizable()
                                .frame(width: 20, height: 19)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("(\(viewModel.waitingInt)/5)")
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
    @State var showFoodImagePicker: Bool = false
    @State var foodImages: [SelectedImage] = []
    var restaurant: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            Group {
                Text("가게 분위기가 어떤가요?")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            for i in 1 ..< viewModel.restaurantMood.count {
                                if viewModel.restaurantMood[i] == true {
                                    viewModel.restaurantMood[i] = false
                                }
                            }
                            viewModel.restaurantMood[0].toggle()
                        }) {
                            Text("활기찬")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.restaurantMood[0], width: 66))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.restaurantMood.count {
                                if i == 1 {
                                    continue
                                }
                                if viewModel.restaurantMood[i] == true {
                                    viewModel.restaurantMood[i] = false
                                }
                            }
                            viewModel.restaurantMood[1].toggle()
                        }) {
                            Text("격식있는")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.restaurantMood[1], width: 78))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.restaurantMood.count {
                                if i == 2 {
                                    continue
                                }
                                if viewModel.restaurantMood[i] == true {
                                    viewModel.restaurantMood[i] = false
                                }
                            }
                            viewModel.restaurantMood[2].toggle()
                        }) {
                            Text("로맨틱")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.restaurantMood[2], width: 66))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.restaurantMood.count {
                                if i == 3 {
                                    continue
                                }
                                if viewModel.restaurantMood[i] == true {
                                    viewModel.restaurantMood[i] = false
                                }
                            }
                            viewModel.restaurantMood[3].toggle()
                        }) {
                            Text("힙한")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.restaurantMood[3], width: 54))
                        
                        Button(action: {
                            for i in 0 ..< (viewModel.restaurantMood.count - 1) {
                                if viewModel.restaurantMood[i] == true {
                                    viewModel.restaurantMood[i] = false
                                }
                            }
                            viewModel.restaurantMood[4].toggle()
                        }) {
                            Text("편안한")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.restaurantMood[4], width: 66))
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
            }
            .font(.system(size: 14))
            
            Group {
                Text("추천하는 메뉴는 무엇인가요?")
                    .font(.system(size: 14))
                
                // Image
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // 이미지 추가 버튼
                        Button(action: {
                            if foodImages.count < 3 {
                                showFoodImagePicker.toggle()
                            }
                        }) {
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
                                    
                                    Text("\(foodImages.count) / 3")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                }
                            }
                        }
                        
                        // 이미지 View
                        ForEach(foodImages, id:\.self) { img in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: img.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                
                                // 이미지 삭제버튼
                                Button(action: {
                                    if let index = foodImages.firstIndex(of: img) {
                                        foodImages.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "multiply")
                                        .resizable()
                                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                        
                        if self.showFoodImagePicker {
                            NavigationLink("", destination: CustomImagePicker(selectedImages: self.$foodImages, showingPicker: self.$showFoodImagePicker), isActive: $showFoodImagePicker)
                        }
                    }
                }
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $viewModel.opinion.recommendFoodDescription)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if viewModel.opinion.recommendFoodDescription == "" {
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
    @State var showCafeImagePicker: Bool = false
    @State var cafeImages: [SelectedImage] = []
    var cafe: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            // 커피 맛
            Group {
                Text("커피 맛이 어떤가요?")
                
                HStack {
                    Button(action: {
                        for i in 1 ..< viewModel.coffee.count {
                            if viewModel.coffee[i] == true {
                                viewModel.coffee[i] = false
                            }
                        }
                        viewModel.coffee[0].toggle()
                    }) {
                        Text("쓴맛")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.coffee[0], width: 66))
                    
                    Button(action: {
                        for i in 0 ..< viewModel.coffee.count {
                            if i == 1 {
                                continue
                            }
                            if viewModel.coffee[i] == true {
                                viewModel.coffee[i] = false
                            }
                        }
                        viewModel.coffee[1].toggle()
                    }) {
                        Text("산미가 강한")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.coffee[1], width: 93))
                    
                    Button(action: {
                        for i in 0 ..< viewModel.coffee.count {
                            if i == 2 {
                                continue
                            }
                            if viewModel.coffee[i] == true {
                                viewModel.coffee[i] = false
                            }
                        }
                        viewModel.coffee[2].toggle()
                    }) {
                        Text("보통")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.coffee[2], width: 54))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
            .font(.system(size: 14))
            
            // 카페 분위기
            Group {
                Text("카페 분위기가 어떤가요?")
                
                HStack {
                    Button(action: {
                        for i in 1 ..< viewModel.cafeMood.count {
                            if viewModel.cafeMood[i] == true {
                                viewModel.cafeMood[i] = false
                            }
                        }
                        viewModel.cafeMood[0].toggle()
                    }) {
                        Text("모던한")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.cafeMood[0], width: 66))
                    
                    Button(action: {
                        for i in 0 ..< viewModel.cafeMood.count {
                            if i == 1 {
                                continue
                            }
                            if viewModel.cafeMood[i] == true {
                                viewModel.cafeMood[i] = false
                            }
                        }
                        viewModel.cafeMood[1].toggle()
                    }) {
                        Text("크고 넓은")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.cafeMood[1], width: 81))
                    
                    Button(action: {
                        for i in 0 ..< viewModel.cafeMood.count {
                            if i == 2 {
                                continue
                            }
                            if viewModel.cafeMood[i] == true {
                                viewModel.cafeMood[i] = false
                            }
                        }
                        viewModel.cafeMood[2].toggle()
                    }) {
                        Text("아기자기한")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.cafeMood[2], width: 91))
                    
                    Button(action: {
                        for i in 0 ..< viewModel.cafeMood.count {
                            if i == 3 {
                                continue
                            }
                            if viewModel.cafeMood[i] == true {
                                viewModel.cafeMood[i] = false
                            }
                        }
                        viewModel.cafeMood[3].toggle()
                    }) {
                        Text("힙한")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.cafeMood[3], width: 54))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
            .font(.system(size: 14))
            
            Group {
                Text("이곳의 추천 음료·디저트는 무엇인가요?")
                    .font(.system(size: 14))
                
                // Image
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // 이미지 추가 버튼
                        Button(action: {
                            if cafeImages.count < 3 {
                                showCafeImagePicker.toggle()
                            }
                        }) {
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
                                    
                                    Text("\(cafeImages.count) / 3")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                }
                            }
                        }
                        
                        // 이미지 View
                        ForEach(cafeImages, id:\.self) { img in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: img.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                
                                // 이미지 삭제버튼
                                Button(action: {
                                    if let index = cafeImages.firstIndex(of: img) {
                                        cafeImages.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "multiply")
                                        .resizable()
                                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                        
                        if self.showCafeImagePicker {
                            NavigationLink("", destination: CustomImagePicker(selectedImages: self.$cafeImages, showingPicker: self.$showCafeImagePicker), isActive: $showCafeImagePicker)
                        }
                    }
                }
                
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $viewModel.opinion.recommendDrinkAndDessertDescription)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if viewModel.opinion.recommendDrinkAndDessertDescription == "" {
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
    @State var showPhotoSpotImagePicker: Bool = false
    @State var photoSpotImages: [SelectedImage] = []
    var sightseeing: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            Group {
                Text("여기서 꼭 해봐야 하는 게 있나요?")
                    .font(.system(size: 14))
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $viewModel.opinion.recommendToDo)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if viewModel.opinion.recommendToDo == "" {
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
                    TextField("", text: $viewModel.opinion.recommendSnack)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if viewModel.opinion.recommendSnack == "" {
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // 이미지 추가 버튼
                        Button(action: {
                            if photoSpotImages.count < 3 {
                                showPhotoSpotImagePicker.toggle()
                            }
                        }) {
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
                                    
                                    Text("\(photoSpotImages.count) / 3")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                }
                            }
                        }
                        
                        // 이미지 View
                        ForEach(photoSpotImages, id:\.self) { img in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: img.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                
                                // 이미지 삭제버튼
                                Button(action: {
                                    if let index = photoSpotImages.firstIndex(of: img) {
                                        photoSpotImages.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "multiply")
                                        .resizable()
                                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                        
                        if self.showPhotoSpotImagePicker {
                            NavigationLink("", destination: CustomImagePicker(selectedImages: self.$photoSpotImages, showingPicker: self.$showPhotoSpotImagePicker), isActive: $showPhotoSpotImagePicker)
                        }
                    }
                }
                
                // TextField
                ZStack(alignment: .leading) {
                    TextField("", text: $viewModel.opinion.photoSpotDescription)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 40)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if viewModel.opinion.photoSpotDescription == "" {
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
                            for i in 1 ..< viewModel.noise.count {
                                if viewModel.noise[i] == true {
                                    viewModel.noise[i] = false
                                }
                            }
                            viewModel.noise[0].toggle()
                        }) {
                            Text("매우 시끄러워요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.noise[0], width: 117))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.noise.count {
                                if i == 1 {
                                    continue
                                }
                                if viewModel.noise[i] == true {
                                    viewModel.noise[i] = false
                                }
                            }
                            viewModel.noise[1].toggle()
                        }) {
                            Text("시끄러워요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.noise[1], width: 93))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.noise.count {
                                if i == 2 {
                                    continue
                                }
                                if viewModel.noise[i] == true {
                                    viewModel.noise[i] = false
                                }
                            }
                            viewModel.noise[2].toggle()
                        }) {
                            Text("그냥 그래요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.noise[2], width: 93))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.noise.count {
                                if i == 3 {
                                    continue
                                }
                                if viewModel.noise[i] == true {
                                    viewModel.noise[i] = false
                                }
                            }
                            viewModel.noise[3].toggle()
                        }) {
                            Text("괜찮아요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.noise[3], width: 78))
                        
                        Button(action: {
                            for i in 0 ..< 4 {
                                if viewModel.noise[i] == true {
                                    viewModel.noise[i] = false
                                }
                            }
                            viewModel.noise[4].toggle()
                        }) {
                            Text("조용해요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.noise[4], width: 78))
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
                            for i in 1 ..< viewModel.deafening.count {
                                if viewModel.deafening[i] == true {
                                    viewModel.deafening[i] = false
                                }
                            }
                            viewModel.deafening[0].toggle()
                        }) {
                            Text("전혀 안돼요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.deafening[0], width: 100))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.deafening.count {
                                if i == 1 {
                                    continue
                                }
                                if viewModel.deafening[i] == true {
                                    viewModel.deafening[i] = false
                                }
                            }
                            viewModel.deafening[1].toggle()
                        }) {
                            Text("잘 안돼요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.deafening[1], width: 93))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.deafening.count {
                                if i == 2 {
                                    continue
                                }
                                if viewModel.deafening[i] == true {
                                    viewModel.deafening[i] = false
                                }
                            }
                            viewModel.deafening[2].toggle()
                        }) {
                            Text("그냥 그래요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.deafening[2], width: 93))
                        
                        Button(action: {
                            for i in 0 ..< viewModel.deafening.count {
                                if i == 3 {
                                    continue
                                }
                                if viewModel.deafening[i] == true {
                                    viewModel.deafening[i] = false
                                }
                            }
                            viewModel.deafening[3].toggle()
                        }) {
                            Text("잘 돼요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.deafening[3], width: 66))
                        
                        Button(action: {
                            for i in 0 ..< (viewModel.deafening.count - 1) {
                                if viewModel.deafening[i] == true {
                                    viewModel.deafening[i] = false
                                }
                            }
                            viewModel.deafening[4].toggle()
                        }) {
                            Text("매우 잘 돼요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.deafening[4], width: 93))
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

struct OpinionWriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpinionWriteScreen(travelOnId: 12)
    }
}
