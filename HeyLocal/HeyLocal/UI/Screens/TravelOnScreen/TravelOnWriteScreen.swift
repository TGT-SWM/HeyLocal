//
//  TravelOnWriteScreen.swift
//  HeyLocal
//  여행On 등록·수정 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnWriteScreen: View {
    /// Navigation Bar Item 관련 변수 및 함수
    /// 1. 뒤로가기 버튼 (커스텀)
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
    /// 2. 작성하기 버튼
    var writeBtn: some View {
        HStack {
            if checkIsFill() {
                if ((isRevise) != nil) {
                    NavigationLink(destination: TravelOnListScreen()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)){
                        Text("수정 완료")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    }.simultaneousGesture(TapGesture().onEnded{
                        makeTravelOnJsonData()
                        viewModel.updateTravelOn(travelOnId: travelOnID!, travelOnData: travelOnData)
                    })
                }
                else {
                    NavigationLink(destination: TravelOnListScreen()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)){
                        Text("작성 완료")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    }.simultaneousGesture(TapGesture().onEnded{
                        makeTravelOnJsonData()
                        if viewModel.postTravelOn(travelOnData: travelOnData) == 201 {
                            viewModel.fetchTravelOnList(lastItemId: nil, pageSize: 15, regionId: nil, sortBy: "DATE", withOpinions: false)
                        }
                    })
                }
            }
            else {
                if ((isRevise) != nil) {
                    Text("수정 완료")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                }
                else {
                    Text("작성 완료")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                }
            }
        }
    }
    
    /// 수정 vs 작성  확인 변수
    var isRevise: Bool?     // "수정하기"에서 넘어왔다면 true
    var travelOnID: Int?    // "수정하기"에서 해당 여행On ID
    
    
    /// POST 변수
    
    
    @State var isFill: Bool = false
    @State var moveBack: Bool = false
    
    // 작성완료 버튼
    @State var travelOnData = TravelOnPost()
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    
    // POST용 JSON Data 만드는 함수
    func makeTravelOnJsonData() {
        let memberString: [String] = ["ALONE", "CHILD", "PARENT", "COUPLE", "FRIEND", "PET"]
        let accomString: [String] = ["HOTEL", "PENSION", "CAMPING", "GUEST_HOUSE", "RESORT", "ALL"]
        let foodString: [String] = ["KOREAN", "WESTERN", "CHINESE", "JAPANESE", "GLOBAL"]
        let drinkString: [String] = ["SOJU", "BEER", "WINE", "MAKGEOLLI", "LIQUOR", "NO_ALCOHOL"]
        let transString: [String] = ["OWN_CAR", "RENT_CAR", "PUBLIC"]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

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
        case .none:
            travelOnData.accommodationMaxCost = 0
        }
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
    
    // 모든 양식이 다 작성되었는지 확인
    func checkIsFill() -> Bool {
        var result: Bool = false
        
        // member · accom · trans · food · drink · taste
        let checkMemberArray = checkArray(array: memberSet)
        let checkAccomArray = checkArray(array: accomSet)
        let checkTransArray = checkArray(array: transSet)
        let checkFoodArray =  checkArray(array: foodSet)
        let checkDrinkArray =  checkArray(array: drinkSet)
        
        if title != "" && description != "" && checkAccomArray && checkMemberArray && checkTransArray && checkFoodArray && checkDrinkArray && accomPrice != nil && (place != fresh) && (sns != noSNS) && (activity != lazy) {
            result = true
        }
        
        return result
    }
    
    let dateFormat: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateFormat = "yyyy-MM-dd"
        
        return df
    }()
    
    // 기본 값 설정
    @State var title: String = ""
    @State var regionName: String = "여행지 입력"
    @State var regionId: Int = 259
    
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    
    @State var description: String = ""
    @State var accomPrice: Price?
    
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
    
    @State var showStartDatePicker: Bool = false
    @State var showEndDatePicker: Bool = false
    
    enum Price: Int, CaseIterable, Identifiable {
        case ten = 100000
        case twenty = 200000
        case thirty = 300000
        case forty = 400000
        case etc = 0
        
        var id: Int { self.rawValue }
    }
    
    
    /// "수정하기" -> 값 채워놔
    func reviseValue() {
        if ((isRevise) != nil) {
            // 제목
            title = viewModel.travelOn.title!
            
            // 지역
            regionId = viewModel.travelOn.region!.id
            regionName = regionNameFormatter(region: viewModel.travelOn.region!)
            // 여행 날짜
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(identifier: "KST")
            startDate = dateFormatter.date(from: viewModel.travelOn.travelStartDate!)!
            endDate = dateFormatter.date(from: viewModel.travelOn.travelEndDate!)!
            
            // 동행자
            for i in 0..<viewModel.travelOn.travelMemberSet!.count {
                switch viewModel.travelOn.travelMemberSet![i].type {
                case "ALONE":
                    memberSet[0] = true
                case "CHILD":
                    memberSet[1] = true
                case "PARENT":
                    memberSet[2] = true
                case "COUPLE":
                    memberSet[3] = true
                case "FRIEND":
                    memberSet[4] = true
                case "PET":
                    memberSet[5] = true
                default:
                    memberSet[0] = true
                }
            }
            
            // 숙소
            for i in 0..<viewModel.travelOn.hopeAccommodationSet!.count {
                switch viewModel.travelOn.hopeAccommodationSet![i].type {
                case "HOTEL":
                    accomSet[0] = true
                case "PENSION":
                    accomSet[1] = true
                case "CAMPING":
                    accomSet[2] = true
                case "GUEST_HOUSE":
                    accomSet[3] = true
                case "RESORT":
                    accomSet[4] = true
                case "ALL":
                    accomSet[5] = true
                default:
                    accomSet[5] = true
                }
            }
            switch viewModel.travelOn.accommodationMaxCost {
            case 100000:
                accomPrice = .ten
            case 200000:
                accomPrice = .twenty
            case 300000:
                accomPrice = .thirty
            case 400000:
                accomPrice = .forty
            case 0:
                accomPrice = .etc
            default:
                accomPrice = .etc
            }
            
            
            // 교통수단
            switch viewModel.travelOn.transportationType {
            case "OWN_CAR":
                transSet[0] = true
                
            case "RENT_CAR":
                transSet[1] = true
                
            case "PUBLIC":
                transSet[2] = true
                
            default:
                transSet[0] = true
            }
            
            // 선호 음식
            for i in 0..<viewModel.travelOn.hopeFoodSet!.count {
                switch viewModel.travelOn.hopeFoodSet![i].type {
                case "KOREAN":
                    foodSet[0] = true
                case "WESTERN":
                    foodSet[1] = true
                case "CHINESE":
                    foodSet[2] = true
                case "JAPANESE":
                    foodSet[3] = true
                case "GLOBAL":
                    foodSet[4] = true
                default:
                    foodSet[4] = true
                }
            }
            
            // 선호 주류
            for i in 0..<viewModel.travelOn.hopeDrinkSet!.count {
                switch viewModel.travelOn.hopeDrinkSet![i].type {
                case "SOJU":
                    drinkSet[0] = true
                case "BEER":
                    drinkSet[1] = true
                case "WINE":
                    drinkSet[2] = true
                case "MAKGEOLLI":
                    drinkSet[3] = true
                case "LIQUOR":
                    drinkSet[4] = true
                case "NO_ALCOHOL":
                    drinkSet[5] = true
                default:
                    drinkSet[5] = true
                }
            }
            
            // 여행 취향
            if viewModel.travelOn.travelTypeGroup!.placeTasteType == "FAMOUS" {
                place = true
            } else {
                fresh = true
            }
            
            if viewModel.travelOn.travelTypeGroup!.activityTasteType == "HARD" {
                activity = true
            } else {
                lazy = true
            }
            
            if viewModel.travelOn.travelTypeGroup!.snsTasteType == "YES" {
                sns = true
            } else {
                noSNS = true
            }
            description = viewModel.travelOn.description!
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                content
            }
            
            // 뒤로가기 버튼 클릭 시 -> Custom Alert 출력
            if moveBack {
                /// 수정하기 취소 -> Detail 화면으로 이동
                if ((isRevise) != nil) {
                    CustomAlert(showingAlert: $moveBack,
                                title: "여행On 수정을 취소할까요?",
                                cancelMessage: "아니요,작성할래요",
                                confirmMessage: "네,취소할래요",
                                cancelWidth: 134,
                                confirmWidth: 109,
                                destinationView: AnyView(TravelOnDetailScreen(travelOnId: travelOnID!)))
                }
                
                /// 작성하기 취소 -> List 화면으로 이동
                else {
                    CustomAlert(showingAlert: $moveBack,
                                title: "여행On 작성을 취소할까요?",
                                cancelMessage: "아니요,작성할래요",
                                confirmMessage: "네,취소할래요",
                                cancelWidth: 134,
                                confirmWidth: 109,
                                destinationView: AnyView(TravelOnListScreen()))
                }
            }
        }
        .onAppear {
            // "수정하기"라면 -> Fetch해와서 값 보여줘
            if ((isRevise) != nil) {
                viewModel.fetchTravelOn(travelOnId: travelOnID!)
                memberSet = viewModel.memberSet
//                reviseValue()
            }
        }
        .navigationTitle("여행On")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: writeBtn)
    }
    
    var content: some View {
        VStack(alignment: .leading){
            // Title
            Group {
                VStack(alignment: .leading) {
                    Text("여행 On 제목")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(height: 3)
                    
                    TextField("  제목 입력", text: $title)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                }
            }
            
            // TODO: Region
            Group {
                Spacer()
                    .frame(height: 15)
                
                VStack(alignment: .leading) {
                    Text("여행지 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(height: 0)
                    
                    Button(action: {}) {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                                .frame(width: 350, height: 36)
                                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                                .cornerRadius(10)
                            
                            HStack {
                                Text("  \(regionName)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                                
                                Spacer()
                                
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color(red: 110 / 255, green: 108 / 255, blue: 106 / 255))
                                    .padding()
                            }
                        }
                    }
                }
            }
            
            // Start Date - End Date
            Group {
                Spacer()
                    .frame(height: 10)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("여행 출발일")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        Spacer()
                            .frame(height: 3)
                        
                        Button {
                            withAnimation {
                                if showEndDatePicker {
                                    showEndDatePicker = false
                                }
                                showStartDatePicker.toggle()
                            }
                           }  label: {
                               ZStack(alignment: .leading) {
                                   Rectangle()
                                       .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                                       .frame(width: 171, height: 36)
                                       .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                                       .cornerRadius(10)
                                   
                                   HStack {
                                       Spacer()
                                           .frame(width: 10)
                                       
                                       Image("calendar_icon")
                                           .resizable()
                                           .scaledToFit()
                                           .frame(width: 16)
                                       
                                       
                                       Text("\(dateFormat.string(from: startDate))")
                                           .font(.system(size: 14))
                                           .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                                   }
                               }
                           }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("여행 도착일")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        Spacer()
                            .frame(height: 3)
                        
                        Button {
                            withAnimation {
                                if showStartDatePicker {
                                    showStartDatePicker = false
                                }
                                showEndDatePicker.toggle()
                            }
                           }  label: {
                               ZStack(alignment: .leading) {
                                   Rectangle()
                                       .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                                       .frame(width: 171, height: 36)
                                       .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                                       .cornerRadius(10)
                                   
                                   HStack {
                                       Spacer()
                                           .frame(width: 10)
                                       
                                       Image("calendar_icon")
                                           .resizable()
                                           .scaledToFit()
                                           .frame(width: 16)
                                       
                                       
                                       Text("\(dateFormat.string(from: endDate))")
                                           .font(.system(size: 14))
                                           .foregroundColor(Color(red: 17/255, green: 17/255, blue: 17/255))
                                   }
                               }
                           }
                    }
                }
                if showStartDatePicker {
                    DatePicker("", selection: $startDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: startDate, perform: { (value) in
                            showStartDatePicker = false
                        })
                        .accentColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                        .frame(width: 350)
                        .background(Color.white)
                }
                
                if showEndDatePicker {
                    DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: endDate, perform: { (value) in
                            showEndDatePicker = false
                        })
                        .accentColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                        .frame(width: 350)
                        .background(Color.white)
                }
                
                Spacer()
                    .frame(height: 20)
                
                Divider()
                
                Spacer()
                    .frame(height: 20)
            }
            
            
            // Member Set
            Group {
                HStack {
                    Text("동행자 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(width: 2)
                    
                    Text("(중복선택 가능)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                }
                
                HStack {
                    Button(action: {
                        if viewModel.memberSet[1] || viewModel.memberSet[2] || viewModel.memberSet[3] || viewModel.memberSet[4] || viewModel.memberSet[5] {
                            for i in 1...5 {
                                viewModel.memberSet[i] = false
                            }
                        }
//                        memberSet[0].toggle()
                        viewModel.memberSet[0].toggle()
                    }) {
                        Text("혼자")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.memberSet[0], width: 54))
                    
                    Button(action: {
                        if viewModel.memberSet[0] {
                            viewModel.memberSet[0] = false
                        }
                        viewModel.memberSet[1].toggle()
                    }) {
                        Text("아이와")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.memberSet[1], width: 66))
                    
                    Button(action: {
                        if viewModel.memberSet[0] {
                            viewModel.memberSet[0] = false
                        }
                        viewModel.memberSet[2].toggle()
                    }) {
                        Text("부모님과")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.memberSet[2], width: 78))
                    
                    Button(action: {
                        if viewModel.memberSet[0] {
                            viewModel.memberSet[0] = false
                        }
                        viewModel.memberSet[3].toggle()
                    }) {
                        Text("연인과")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.memberSet[3], width: 66))
                }
                
                HStack {
                    Button(action: {
                        if viewModel.memberSet[0] {
                            viewModel.memberSet[0] = false
                        }
                        viewModel.memberSet[4].toggle()
                    }) {
                        Text("친구와")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.memberSet[4], width: 66))
                    
                    Button(action: {
                        if viewModel.memberSet[0] {
                            viewModel.memberSet[0] = false
                        }
                        viewModel.memberSet[5].toggle()
                    }) {
                        Text("반려동물과")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.memberSet[5], width: 91))
                }
                
                Spacer()
                    .frame(height: 20)
            }
            
            // Accom Set
            Group {
                HStack {
                    Text("선호 숙소형태 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(width: 2)
                    
                    Text("(중복선택 가능)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    
                    Spacer()
                    
                    Menu {
                        Picker(selection: $accomPrice) {
                            ForEach(Price.allCases, id:\.id) { value in
                                switch value {
                                case .ten:
                                    Text("10만원 이하")
                                        .tag(value as Price?)
                                        .font(.system(size: 12))
                                    
                                case .twenty:
                                    Text("20만원 이하")
                                        .tag(value as Price?)
                                        .font(.system(size: 12))
                                    
                                case .thirty:
                                    Text("30만원 이하")
                                        .tag(value as Price?)
                                        .font(.system(size: 12))
                                    
                                case .forty:
                                    Text("40만원 이하")
                                        .tag(value as Price?)
                                        .font(.system(size: 12))
                                    
                                case .etc:
                                    Text("상관없어요")
                                        .tag(value as Price?)
                                        .font(.system(size: 12))
                                }
                            }
                        } label: {}
                    } label : {
                        HStack {
                            switch accomPrice {
                            case .ten:
                                Text("10만원 이하")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                
                            case .twenty:
                                Text("20만원 이하")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                
                            case .thirty:
                                Text("30만원 이하")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                
                            case .forty:
                                Text("40만원 이하")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                
                            case .etc:
                                Text("상관없어요")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                
                            default:
                                Text("가격대 선택")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                            }
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10)
                                .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                        }
                    }.id(accomPrice)
                }
                
                HStack {
                    Button(action: {
                        if accomSet[5] {
                            accomSet[5] = false
                        }
                        accomSet[0].toggle()
                    }) {
                        Text("호텔")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $accomSet[0], width: 54))
                    
                    Button(action: {
                        if accomSet[5] {
                            accomSet[5] = false
                        }
                        accomSet[1].toggle()
                    }) {
                        Text("펜션")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $accomSet[1], width: 54))
                    
                    Button(action: {
                        if accomSet[5] {
                            accomSet[5] = false
                        }
                        accomSet[2].toggle()
                    }) {
                        Text("캠핑/글램핑")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $accomSet[2], width: 96))
                    
                    Button(action: {
                        if accomSet[5] {
                            accomSet[5] = false
                        }
                        accomSet[3].toggle()
                    }) {
                        Text("리조트")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $accomSet[3], width: 66))
                }
                
                HStack{
                    Button(action: {
                        if accomSet[5] {
                            accomSet[5] = false
                        }
                        accomSet[4].toggle()
                    }) {
                        Text("게스트하우스/민박")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $accomSet[4], width: 133))
                    
                    Button(action: {
                        if accomSet[0] || accomSet[1] || accomSet[2] || accomSet[3] || accomSet[4] {
                            for i in 0...4 {
                                accomSet[i] = false
                            }
                        }
                        accomSet[5].toggle()
                    }) {
                        Text("숙소 어디든")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $accomSet[5], width: 93))
                }
                
                Spacer()
                    .frame(height: 20)
            }
            
            // Transportation Set
            Group {
                Text("교통수단 선택")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                
                HStack {
                    Button(action: {
                        if transSet[1] || transSet[2] {
                            transSet[1] = false
                            transSet[2] = false
                        }
                        
                        transSet[0].toggle()
                    }) {
                        Text("자가용")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $transSet[0], width: 66))
                    
                    Button(action: {
                        if transSet[0] || transSet[2] {
                            transSet[0] = false
                            transSet[2] = false
                        }
                        
                        transSet[1].toggle()
                    }) {
                        Text("렌트카")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $transSet[1], width: 66))
                    
                    Button(action: {
                        if transSet[0] || transSet[1] {
                            transSet[0] = false
                            transSet[1] = false
                        }
                        
                        transSet[2].toggle()
                    }) {
                        Text("대중교통")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $transSet[2], width: 78))
                }
                
                Spacer()
                    .frame(height: 20)
            }
            
            // Food Set
            Group {
                HStack {
                    Text("선호 음식 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(width: 2)
                    
                    Text("(중복선택 가능)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                }
                
                HStack {
                    Button(action: {
                        foodSet[0].toggle()
                    }) {
                        Text("한식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $foodSet[0], width: 54))
                    
                    Button(action: {
                        foodSet[1].toggle()
                    }) {
                        Text("양식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $foodSet[1], width: 54))
                    
                    Button(action: {
                        foodSet[2].toggle()
                    }) {
                        Text("중식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $foodSet[2], width: 54))
                    
                    Button(action: {
                        foodSet[3].toggle()
                    }) {
                        Text("일식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $foodSet[3], width: 54))
                    
                    Button(action: {
                        foodSet[4].toggle()
                    }) {
                        Text("세계음식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $foodSet[4], width: 78))
                }
                
                Spacer()
                    .frame(height: 20)
            }
            
            // Drink Set
            Group {
                HStack {
                    Text("선호 음주류 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(width: 2)
                    
                    Text("(중복선택 가능)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                }
                
                HStack {
                    Button(action: {
                        if drinkSet[5] {
                            drinkSet[5] = false
                        }
                        drinkSet[0].toggle()
                    }) {
                        Text("소주")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $drinkSet[0], width: 54))
                    
                    Button(action: {
                        if drinkSet[5] {
                            drinkSet[5] = false
                        }
                        drinkSet[1].toggle()
                    }) {
                        Text("맥주")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $drinkSet[1], width: 54))
                    
                    Button(action: {
                        if drinkSet[5] {
                            drinkSet[5] = false
                        }
                        drinkSet[2].toggle()
                    }) {
                        Text("와인")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $drinkSet[2], width: 54))
                    
                    Button(action: {
                        if drinkSet[5] {
                            drinkSet[5] = false
                        }
                        drinkSet[3].toggle()
                    }) {
                        Text("막걸리")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $drinkSet[3], width: 66))
                }
                
                HStack {
                    Button(action: {
                        if drinkSet[5] {
                            drinkSet[5] = false
                        }
                        drinkSet[4].toggle()
                    }) {
                        Text("칵테일/양주")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $drinkSet[4], width: 96))
                    
                    Button(action: {
                        if drinkSet[0] || drinkSet[1] || drinkSet[2] || drinkSet[3] || drinkSet[4] {
                            for i in 0...4 {
                                drinkSet[i] = false
                            }
                        }
                        drinkSet[5].toggle()
                    }) {
                        Text("음주 비선호")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $drinkSet[5], width: 93))
                }
                
                Spacer()
                    .frame(height: 20)
            }
            
            // Travel Taste Set
            Group {
                Text("여행취향")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                
                Spacer()
                    .frame(height: 10)
                
                Group {
                    Text("어떤 곳을 선호하시나요?")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Button(action: {
                            if fresh {
                                fresh = false
                            }
                            place.toggle()
                        }) {
                            Text("웨이팅 필수! 인기있는 곳")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $place, width: 164))
                        
                        Button(action: {
                            if place {
                                place = false
                            }
                            fresh.toggle()
                        }) {
                            Text("알려지지 않은 참신한 곳")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $fresh, width: 163))
                    }
                }
                
                Spacer()
                    .frame(height: 15)
                
                Group {
                    Text("어떤 여행 스타일을 선호하시나요?")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Button(action: {
                            if lazy {
                                lazy = false
                            }
                            activity.toggle()
                        }) {
                            Text("부지런한 여행")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $activity, width: 106))
                        
                        Button(action: {
                            if activity {
                                activity = false
                            }
                            lazy.toggle()
                        }) {
                            Text("느긋한 여행")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $lazy, width: 93))
                    }
                }
                
                Spacer()
                    .frame(height: 15)
                
                Group {
                    Text("SNS를 즐겨하시나요?")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Button(action: {
                            if noSNS {
                                noSNS = false
                            }
                            sns.toggle()
                        }) {
                            Text("SNS 핫플레이스 탐방")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $sns, width: 147))
                        
                        Button(action: {
                            if sns {
                                sns = false
                            }
                            noSNS.toggle()
                        }) {
                            Text("SNS 하지않아요")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $noSNS, width: 121))
                    }
                }
                Spacer()
                    .frame(height: 20)
            }
            
            // Description
            Group {
                Text("기타 요구사항")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                
                ZStack(alignment: .topLeading) {
                    TextField("", text: $description)
                        .multilineTextAlignment(TextAlignment.leading)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                        .frame(width: 350, height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                    
                    if description == "" {
                        VStack(alignment: .leading) {
                            Text("자세할수록 좋아요, ")
                            Text("원하시는 여행 스타일, 취향을 말해주세요!")
                        }
                        .padding()
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                    
                }
            }
        }
        .frame(width: 350, alignment: .leading)
    }
}


struct TravelOnWriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnWriteScreen()
    }
}
