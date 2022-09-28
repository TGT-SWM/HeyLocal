//
//  TravelOnWriteScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnWriteScreen: View {
    enum Price: String, CaseIterable, Identifiable {
        case ten = "10만원"
        case twenty = "20만원"
        case thirty = "30만원"
        case forty = "40만원"
        case etc = "상관 없어요"
        
        var id: String { self.rawValue }
    }
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    @State var isActive = false
    
    @State var title: String = ""
    @State var regionId: Int = 259
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var accomPrice: Price = .ten
    @State var foodPrice: Price = .ten
    @State var drinkPrice: Price = .ten
    @State var description: String = ""

   // ALONE, CHILD, PARENT, COUPLE, FRIEND, PET
    @State var memberSet: [Bool] = [false, false, false, false, false, false]
    // HOTEL, PENSION, CAMPING, GUEST_HOUSE, RESORT, ALL
    @State var accomSet: [Bool] = [false, false, false, false, false, false]
    // OWN_CAR, RENT_CAR, PUBLIC
    @State var transSet: [Bool] = [false, false, false]
    // KOREAN, WESTERN, CHINESE, JAPANESE, GLOBAL
    @State var foodSet: [Bool] = [false, false, false, false, false]
    // SOJU, BEER, WINE, MAKGEOLLI, LIQUOR, NO_ALCOHOL
    @State var drinkSet: [Bool] = [false, false, false, false, false, false]
    // FAMOUS, FRESH
    @State var place: Bool = false
    @State var fresh: Bool = false
    // HARD, LAZY
    @State var activity: Bool = false
    @State var lazy: Bool = false
    // NO, YES
    @State var sns: Bool = false
    @State var noSNS: Bool = false
    
    
    
    @State var travelOnData = TravelOnPost()
    var body: some View {
        ScrollView {
            // Title
            Group {
                VStack{
                    Text("여행 On 제목")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    TextField("", text: $title)
                        .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.05)
                        .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                }
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
            }
            
            // Where
            Group {
                VStack {
                    Text("어디로")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    Rectangle()
                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.05)
                }
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
                
                // TODO: 지역 Picker 구현
            }
            
            
            // When
            Group {
                VStack {
                    Text("언제")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            DatePicker("출발 날짜", selection: $startDate, displayedComponents: .date)
                                .font(.system(size: 18))
                        }
                        
                        HStack {
                            DatePicker("종료 날짜", selection: $endDate, displayedComponents: .date)
                                .font(.system(size: 18))
                        }
                        
                    }
                    .frame(width: ScreenSize.width * 0.9)
                }
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
            }
            
            // With Whom
            Group {
                VStack {
                    Text("누구와")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        Button(action: {
                            memberSet[0].toggle()
                        }) {
                            Text("혼자")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $memberSet[0]))
                        
                        Button(action: {
                            memberSet[1].toggle()
                        }) {
                            Text("아이와")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $memberSet[1]))
                        .padding()
                        
                        
                        Button(action: {
                            memberSet[2].toggle()
                        }) {
                            Text("부모님과")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $memberSet[2]))
                        
                    }
                    .frame(width: ScreenSize.width * 0.9)
                   
                    HStack {
                        Button(action: {
                            memberSet[3].toggle()
                        }) {
                            Text("연인과")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $memberSet[3]))
                        
                        Button(action: {
                            memberSet[4].toggle()
                        }) {
                            Text("친구와")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $memberSet[4]))
                        .padding()
                        
                        
                        Button(action: {
                            memberSet[5].toggle()
                        }) {
                            Text("반려동물과")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $memberSet[5]))
                    }
                    .frame(width: ScreenSize.width * 0.9)
                }
                
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
            }
            
            
            // Accom
            Group {
                VStack {
                    Text("숙소")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    Spacer()
                        .frame(height: 13)
                    
                    HStack {
                        Text("비용")
                            .font(.system(size: 20))
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                        
                        Picker("비용", selection: $accomPrice){
                            ForEach(Price.allCases) { p in
                                Text(p.rawValue)
                            }
                        }
                        
                        Text("이하")
                            .font(.system(size: 20))
                        
                        
                    }
                    .frame(width: ScreenSize.width * 0.9)
                    
                    HStack {
                        Button(action: {
                            accomSet[0].toggle()
                        }) {
                            Text("호텔")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $accomSet[0]))
                        
                        Button(action: {
                            accomSet[1].toggle()
                        }) {
                            Text("펜션")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $accomSet[1]))
                        .padding()
                        
                        
                        Button(action: {
                            accomSet[2].toggle()
                        }) {
                            Text("캠핑/글램핑")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $accomSet[2]))
                    }
                    .frame(width: ScreenSize.width * 0.9)
                   
                    HStack {
                        Button(action: {
                            accomSet[3].toggle()
                        }) {
                            Text("게스트하우스")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $accomSet[3]))
                        
                        Button(action: {
                            accomSet[4].toggle()
                        }) {
                            Text("리조트")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $accomSet[4]))
                        .padding()
                        
                        
                        Button(action: {
                            accomSet[5].toggle()
                        }) {
                            Text("상관 없어요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $accomSet[5]))
                    }
                    .frame(width: ScreenSize.width * 0.9)
                    
                    
                }
                
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
            }
            
            
            // Trans
            Group {
                VStack {
                    Text("교통수단")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        Button(action: {
                            transSet[0].toggle()
                        }) {
                            Text("자가용")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $transSet[0]))
                        
                        Button(action: {
                            transSet[1].toggle()
                        }) {
                            Text("렌트카")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $transSet[1]))
                        .padding()
                        
                        
                        Button(action: {
                            transSet[2].toggle()
                        }) {
                            Text("대중교통")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $transSet[2]))
                    }
                    .frame(width: ScreenSize.width * 0.9)
                }
                
            } // end of Group
            
            
            // Food
            Group {
                VStack {
                    Text("음식")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        Text("비용")
                            .font(.system(size: 20))
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                        
                        Picker("비용", selection: $foodPrice){
                            ForEach(Price.allCases) { p in
                                Text(p.rawValue)
                            }
                        }
                        
                        Text("이하")
                            .font(.system(size: 20))
                        
                        
                    }
                    .frame(width: ScreenSize.width * 0.9)
                    
                    HStack {
                        Button(action: {
                            foodSet[0].toggle()
                        }) {
                            Text("한식")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $foodSet[0]))
                        
                        Button(action: {
                            foodSet[1].toggle()
                        }) {
                            Text("양식")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $foodSet[1]))
                        .padding()
                        
                        
                        Button(action: {
                            foodSet[2].toggle()
                        }) {
                            Text("중식")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $foodSet[2]))
                    }
                    .frame(width: ScreenSize.width * 0.9)
                   
                    HStack {
                        Button(action: {
                            foodSet[3].toggle()
                        }) {
                            Text("일식")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $foodSet[3]))
                        
                        Button(action: {
                            foodSet[4].toggle()
                        }) {
                            Text("세계음식")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $foodSet[4]))
                        .padding()
                    }
                    .frame(width: ScreenSize.width * 0.9, alignment: .leading)
                }
                
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
            } // end of Group
            
            // Drink
            Group {
                VStack {
                    Text("음주")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        Text("비용")
                            .font(.system(size: 20))
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                        
                        Picker("비용", selection: $drinkPrice){
                            ForEach(Price.allCases) { p in
                                Text(p.rawValue)
                            }
                        }
                        
                        Text("이하")
                            .font(.system(size: 20))
                        
                        
                    }
                    .frame(width: ScreenSize.width * 0.9)
                    
                    HStack {
                        Button(action: {
                            drinkSet[0].toggle()
                        }) {
                            Text("소주")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $drinkSet[0]))
                        
                        Button(action: {
                            drinkSet[1].toggle()
                        }) {
                            Text("맥주")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $drinkSet[1]))
                        .padding()
                        
                        Button(action: {
                            drinkSet[2].toggle()
                        }) {
                            Text("와인")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $drinkSet[2]))
                    }
                    .frame(width: ScreenSize.width * 0.9)
                   
                    HStack {
                        Button(action: {
                            drinkSet[3].toggle()
                        }) {
                            Text("막걸리")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $drinkSet[3]))
                        
                        Button(action: {
                            drinkSet[4].toggle()
                        }) {
                            Text("칵테일/양주")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $drinkSet[4]))
                        .padding()
                        
                        Button(action: {
                            drinkSet[5].toggle()
                        }) {
                            Text("술은 안마셔요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $drinkSet[5]))
                        
                    }
                    .frame(width: ScreenSize.width * 0.9)
                }
                
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
            } // end of Group
            
            
            // Travel Fav.
            Group {
                VStack {
                    Text("여행 취향")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    
                    HStack {
                        Button(action: {
                            place.toggle()
                        }) {
                            Text("인기 있는 곳")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $place))
                        .padding()
                        
                        Button(action: {
                            fresh.toggle()
                        }) {
                            Text("참신한 곳")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $fresh))
                    }
                    .frame(width: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        Button(action: {
                            activity.toggle()
                        }) {
                            Text("부지런")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $activity))
                        .padding()
                        
                        Button(action: {
                            lazy.toggle()
                        }) {
                            Text("느긋한")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $lazy))
                    }
                    .frame(width: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        Button(action: {
                            sns.toggle()
                        }) {
                            Text("SNS 유명장소")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $sns))
                        .padding()
                        
                        Button(action: {
                            noSNS.toggle()
                        }) {
                            Text("SNS 안해요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noSNS))
                        
                    }
                    .frame(width: ScreenSize.width * 0.9, alignment: .leading)
                   
                    
                }
                
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
            } // end of Group
            
            // Travel Fav.
            Group {
                VStack {
                    Text("설명")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    TextField("", text: $description)
                        .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.1)
                        .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                }
                
                NavigationLink(destination: TravelOnListScreen()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)) {
                    Text("작성 완료")
                }.simultaneousGesture(TapGesture().onEnded{
                    makeTavelOnJsonData()
//                    viewModel.postTravelOn(travelOnData: travelOnData)
                    // 응답 코드 확인 후 fetch !!
                    if viewModel.postTravelOn(travelOnData: travelOnData) == 201 {
                        viewModel.fetchTravelOnList(lastItemId: nil, pageSize: 5, regionId: nil, sortBy: "DATE", withOpinions: false, withNonOpinions: false)
                    }
                })
            } // end of Group
        }
    }
    
    // 누구와 · 숙소 · 음주 -> 중복 선택 확인 
    func checkValue() {
        
    }
    
    func makeTavelOnJsonData() {
        let memberString: [String] = ["ALL", "CHILD", "PARENT", "COUPLE", "FRIEND", "PET"] // 6
        let accomString: [String] = ["HOTEL", "PENSION", "CAMPING", "GUEST_HOUSE", "RESORT", "ALL"] // 6
        let foodString: [String] = ["KOREAN", "WESTERN", "CHINESE", "JAPANESE", "GLOBAL"] // 5
        let drinkString: [String] = ["SOJU", "BEER", "WINE", "MAKGEOLLI", "LIQUOR", "NO_ALCOHOL"] // 6
        let transString: [String] = ["OWN_CAR", "RENT_CAR", "PUBLIC"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print("memberSet: \(memberSet)")
        print("accomSet: \(accomSet)")
        print("drinkSet: \(drinkSet)")
        print("foodSet: \(foodSet)")
        print("transSet: \(transSet)")
        
        
        
        // memberTypeSet, accommodationTypeSet, drinkTypeSet
        for i in 0..<6 {
            if memberSet[i] == true {
                travelOnData.memberTypeSet.append(memberString[i])
            }
            
            if accomSet[i] == true {
                travelOnData.accommodationTypeSet.append(accomString[i])
            }
            
            if drinkSet[i] == true {
                travelOnData.drinkTypeSet.append(drinkString[i])
            }
        }
        
        // foodTypeSet
        for i in 0..<5 {
            if foodSet[i] == true {
                travelOnData.foodTypeSet.append(foodString[i])
            }
        }
        
        // transportationType
        for i in 0..<3 {
            if transSet[i] == true {
                travelOnData.transportationType = transString[i]
                break
            }
        }
        
        travelOnData.title = title
        travelOnData.description = description
        travelOnData.regionId = regionId
        travelOnData.travelStartDate = dateFormatter.string(from: startDate)
        travelOnData.travelEndDate = dateFormatter.string(from: endDate)
        
        
        if !place {
            travelOnData.travelTypeGroup.placeTasteType = "FRESH"
        }
        
        if !activity {
            travelOnData.travelTypeGroup.activityTasteType = "LAZY"
        }
        
        if !sns {
            travelOnData.travelTypeGroup.snsTasteType = "NO"
        }
        
        switch accomPrice {
        case .ten:
            travelOnData.accommodationMaxCost = 100000
        case .twenty:
            travelOnData.accommodationMaxCost = 200000
        case .thirty:
            travelOnData.accommodationMaxCost = 300000
        case .forty:
            travelOnData.accommodationMaxCost = 400000
        case .etc:
            travelOnData.accommodationMaxCost = 0
        }
        
        switch foodPrice {
        case .ten:
            travelOnData.foodMaxCost = 100000
        case .twenty:
            travelOnData.foodMaxCost = 200000
        case .thirty:
            travelOnData.foodMaxCost = 300000
        case .forty:
            travelOnData.foodMaxCost = 400000
        case .etc:
            travelOnData.foodMaxCost = 0
        }
        
        switch drinkPrice {
        case .ten:
            travelOnData.drinkMaxCost = 100000
        case .twenty:
            travelOnData.drinkMaxCost = 200000
        case .thirty:
            travelOnData.drinkMaxCost = 300000
        case .forty:
            travelOnData.drinkMaxCost = 400000
        case .etc:
            travelOnData.drinkMaxCost = 0
        }
        
    }
}

struct TravelOnWriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnWriteScreen()
    }
}
