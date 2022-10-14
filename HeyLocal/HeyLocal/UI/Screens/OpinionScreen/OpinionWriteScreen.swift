//
//  OpinionWriteScreen.swift
//  HeyLocal
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
    var writeBtn: some View {
        HStack {
            if isFill() {
                NavigationLink(destination: TravelOnDetailScreen(travelOnId: travelOnId)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)) {
                    Text("작성 완료")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    }.simultaneousGesture(TapGesture().onEnded{
                        // make()
                        // post()
                    })
            }
            else {
                Text("작성 완료")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            }
        }
    }
    func isFill() -> Bool {
        let result: Bool = false
        return result
    }
    
    
    
    // MARK: - body
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                content
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
    
    
    
    @State var description: String = ""
    @State var clean: [Bool] = [false, false, false, false, false]
    @State var cost: [Bool] = [false, false, false, false, false]
    @State var yesParking: Bool = false
    @State var noParking: Bool = false
    @State var yesWaiting: Bool = false
    @State var noWaiting: Bool = false
    
    @State var isPhotoPicker: Bool = false
    @State var generalImages: [UIImage] = [UIImage]()
    @State var place: Place? = nil
    
    // MARK: - 장소 선택, 사진, 설명
    var content: some View {
        VStack(alignment: .leading) {
            // 장소 -> NavigationLink 장소 선택
//            NavigationLink(destination: PlaceSearchScreen(onComplete: {})) {
//                ZStack(alignment: .leading) {
//                    Rectangle()
//                        .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
//                        .frame(width: 350, height: 36)
//                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
//                        .cornerRadius(10)
//
//
//                    HStack {
//                        Text("  장소 검색")
//                            .font(.system(size: 12))
//                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
//
//                        Spacer()
//
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(Color(red: 110 / 255, green: 108 / 255, blue: 106 / 255))
//                            .padding()
//                    }
//                }
//            }
//
            Button(action: {}) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .frame(width: 350, height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .cornerRadius(10)
                        
                    
                    HStack {
                        Text("  장소 검색")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        
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
                    Text("\(generalImages.count)")
    
                    Button(action: {
                        isPhotoPicker.toggle()
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                                .cornerRadius(10)
                            
                            ZStack {
                                Circle()
                                    .fill(Color(red: 255/255, green: 153/255, blue: 0/255))
                                    .frame(width: 24, height: 24)
                                
                                Image(systemName: "plus")
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                    .sheet(isPresented: $isPhotoPicker, content: {
//                        ImagePicker(isPresent: $isPhotoPicker, images: $generalImages)
                    })
                }
            }
            
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
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            
            // 공통 질문
            common
            
            // 카테고리별 질문
            cafe
            sightseeing
            restaurant
            accommodation
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Button(action: {
                                for i in 1 ..< clean.count {
                                    clean[i] = false
                                }
                                clean[0].toggle()
                            }) {
                                Text("매우 지저분해요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $clean[0], width: 117))
                            
                            Button(action: {
                                for i in 0 ..< clean.count {
                                    if i == 1 {
                                        continue
                                    }
                                    if clean[i] == true {
                                        clean[i] = false
                                    }
                                }
                                clean[1].toggle()
                            }) {
                                Text("지저분해요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $clean[1], width: 91))
                            
                            Button(action: {
                                for i in 0 ..< clean.count {
                                    if i == 2 {
                                        continue
                                    }
                                    if clean[i] == true {
                                        clean[i] = false
                                    }
                                }
                                clean[2].toggle()
                            }) {
                                Text("그냥 그래요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $clean[2], width: 93))
                            
                            Button(action: {
                                for i in 0 ..< clean.count {
                                    if i == 3 {
                                        continue
                                    }
                                    if clean[i] == true {
                                        clean[i] = false
                                    }
                                }
                                clean[3].toggle()
                            }) {
                                Text("청결해요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $clean[3], width: 78))
                            
                            Button(action: {
                                for i in 0 ..< (clean.count - 1) {
                                    clean[i] = false
                                }
                                clean[4].toggle()
                            }) {
                                Text("매우 청결해요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $clean[4], width: 104))
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                
                
                Group {
                    Text("주차장이 있나요?")
                    
                    HStack {
                        Button(action: {
                            if noParking {
                                noParking.toggle()
                            }
                            yesParking.toggle()
                        }) {
                            Text("있어요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $yesParking, width: 66))
                        
                        Button(action: {
                            if yesParking {
                                yesParking.toggle()
                            }
                            noParking.toggle()
                        }) {
                            Text("없어요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                
                Group {
                    Text("웨이팅이 있나요?")
                    HStack {
                        Button(action: {
                            if noWaiting {
                                noWaiting.toggle()
                            }
                            yesWaiting.toggle()
                        }) {
                            Text("있어요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $yesWaiting, width: 66))
                        
                        Button(action: {
                            if yesWaiting {
                                yesWaiting.toggle()
                            }
                            noWaiting.toggle()
                        }) {
                            Text("없어요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noWaiting, width: 66))
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                
                Group {
                    Text("비용이 합리적인가요?")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Button(action: {
                                for i in 1 ..< cost.count {
                                    if cost[i] == true {
                                        cost[i] = false
                                    }
                                }
                                cost[0].toggle()
                            }) {
                                Text("매우 비싸요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $cost[0], width: 93))
                            
                            Button(action: {
                                for i in 0 ..< cost.count {
                                    if i == 1 {
                                        continue
                                    }
                                    if cost[i] == true {
                                        cost[i] = false
                                    }
                                }
                                cost[1].toggle()
                            }) {
                                Text("비싸요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $cost[1], width: 66))
                            
                            Button(action: {
                                for i in 0 ..< cost.count {
                                    if i == 2 {
                                        continue
                                    }
                                    if cost[i] == true {
                                        cost[i] = false
                                    }
                                }
                                cost[2].toggle()
                            }) {
                                Text("그냥 그래요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $cost[2], width: 93))
                            
                            Button(action: {
                                for i in 0 ..< cost.count {
                                    if i == 3 {
                                        continue
                                    }
                                    if cost[i] == true {
                                        cost[i] = false
                                    }
                                }
                                cost[3].toggle()
                            }) {
                                Text("합리적이에요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $cost[3], width: 103))
                            
                            Button(action: {
                                for i in 0 ..< (cost.count - 1) {
                                    if cost[i] == true {
                                        cost[i] = false
                                    }
                                }
                                cost[4].toggle()
                            }) {
                                Text("저렴해요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $cost[4], width: 78))
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
            }
            .font(.system(size: 14))
            
        }
        
    }
    
    // LIVELY, FORMAL, ROMANTIC, HIP, COMFORTABLE
    @State var restaurantMood: [Bool] = [false, false, false, false, false]
    @State var recommendMenu: String = ""
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
    
    @State var drinkOrDessert: String = ""
    // MODERN, LARGE, CUTE, HIP
    @State var cafeMood: [Bool] = [false, false, false, false]
    // BITTER, SOUR, GENERAL
    @State var coffeeTaste: [Bool] = [false, false, false]
    
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
    
    @State var haveToDo: String = ""
    @State var snack: String = ""
    @State var photoSpot: String = ""
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


// MARK: - Image Picker



struct OpinionWriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpinionWriteScreen(travelOnId: 12)
    }
}
