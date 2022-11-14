//
//  TravelOnWriteScreen.swift
//  HeyLocal
//  여행On 등록·수정 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnWriteScreen: View {
    // MARK: - Navigation Bar Item 관련 변수 및 함수
    // 뒤로가기 버튼
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
    // 작성하기 버튼
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
                        viewModel.fetchTravelOn(travelOnId: travelOnID!)
                        dismiss()
                    })
                }
                else {
                    Button(action: {
                        makeTravelOnJsonData()
                        if viewModel.postTravelOn(travelOnData: travelOnData) == 201 {
                            viewModel.fetchTravelOnList(keyword: "", regionId: nil, sortBy: "DATE", withOpinions: false)
                        }
                        dismiss()
                    }) {
                        Text("작성 완료")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    }
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
    
    // MARK: - 수정하기 확인용 변수
    var isRevise: Bool?     // "수정하기"에서 넘어왔다면 true
    var travelOnID: Int?    // "수정하기"에서 해당 여행On ID
    
    // 작성완료 버튼
    @State var travelOnData = TravelOnPost()
    
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
            if viewModel.travelOnArray.memberSet[i] == true {
                travelOnData.memberTypeSet.append(memberString[i])
            }

            if viewModel.travelOnArray.accomSet[i] == true {
                travelOnData.accommodationTypeSet.append(accomString[i])
            }

            if viewModel.travelOnArray.drinkSet[i] == true {
                travelOnData.drinkTypeSet.append(drinkString[i])
            }
        }

        // foodTypeSet
        for i in 0..<5 {
            if viewModel.travelOnArray.foodSet[i] == true {
                travelOnData.foodTypeSet.append(foodString[i])
            }
        }

        // transportationType
        for i in 0..<3 {
            if viewModel.travelOnArray.transSet[i] == true {
                travelOnData.transportationType = transString[i]
                break
            }
        }
        travelOnData.title = viewModel.travelOnArray.title
        travelOnData.description = viewModel.travelOnArray.description
        travelOnData.regionId = viewModel.travelOnArray.regionId!
        travelOnData.travelStartDate = dateFormatter.string(from: viewModel.travelOnArray.startDate)
        travelOnData.travelEndDate = dateFormatter.string(from: viewModel.travelOnArray.endDate)

        if !viewModel.travelOnArray.place {
            travelOnData.travelTypeGroup.placeTasteType = "FRESH"
        }

        if !viewModel.travelOnArray.activity {
            travelOnData.travelTypeGroup.activityTasteType = "LAZY"
        }

        if !viewModel.travelOnArray.sns {
            travelOnData.travelTypeGroup.snsTasteType = "NO"
        }

        switch viewModel.travelOnArray.accomPrice {
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

    
    // MARK: - 모든 양식이 다 작성되었는지 확인
    func checkIsFill() -> Bool {
        var result: Bool = false
        
        // member · accom · trans · food · drink · taste
        let checkMemberArray = checkArray(array: viewModel.travelOnArray.memberSet)
        let checkAccomArray = checkArray(array: viewModel.travelOnArray.accomSet)
        let checkTransArray = checkArray(array: viewModel.travelOnArray.transSet)
        let checkFoodArray =  checkArray(array: viewModel.travelOnArray.foodSet)
        let checkDrinkArray =  checkArray(array: viewModel.travelOnArray.drinkSet)
        
        if viewModel.travelOnArray.title != "" && viewModel.travelOnArray.regionId != nil && viewModel.travelOnArray.description != "" && checkAccomArray && checkMemberArray && checkTransArray && checkFoodArray && checkDrinkArray && viewModel.travelOnArray.accomPrice != nil && (viewModel.travelOnArray.place != viewModel.travelOnArray.fresh) && (viewModel.travelOnArray.sns != viewModel.travelOnArray.noSNS) && (viewModel.travelOnArray.activity != viewModel.travelOnArray.lazy) {
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
    let dateFormat: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateFormat = "yyyy-MM-dd"
        
        return df
    }()
    

    
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayTabBar) var displayTabBar
    @State var showStartDatePicker: Bool = false
    @State var showEndDatePicker: Bool = false
    @State var moveBack: Bool = false
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    @StateObject var regionViewModel = RegionPickerScreen.ViewModel()
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                travelDateInfo
                
                Spacer()
                    .frame(height: 8)
                
                travelInfo
                
                Spacer()
                    .frame(height: 8)
                
                travelType
                
                Spacer()
                    .frame(height: 8)
                
                descriptionView
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
                                rightButtonAction: { dismiss() })
                }
                
                /// 작성하기 취소 -> List 화면으로 이동
                else {
                    CustomAlert(showingAlert: $moveBack,
                                title: "여행On 작성을 취소할까요?",
                                cancelMessage: "아니요,작성할래요",
                                confirmMessage: "네,취소할래요",
                                cancelWidth: 134,
                                confirmWidth: 109,
                                rightButtonAction: { dismiss() })
                }
            }
        }
        .background(Color("lightGray"))
        .onAppear {
            // "수정하기"라면 -> Fetch해와서 값 보여줘
            if ((isRevise) != nil) {
                viewModel.fetchTravelOn(travelOnId: travelOnID!)
            }
            displayTabBar(false)
        }
        .navigationTitle("여행On 작성")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: writeBtn)
    }
    
    
    // MARK: - 여행On 제목 · 여행지 · 여행 출발일 · 여행 도착일
    var travelDateInfo: some View {
        VStack(alignment: .leading) {
            /// 여행On 제목
            Group {
                VStack(alignment: .leading) {
                    Text("여행 On 제목")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(height: 3)
                    
                    TextField("제목 입력", text: $viewModel.travelOnArray.title)
                        .font(.system(size: 12))
                        .padding()
                        .foregroundColor(Color("gray"))
                        .frame(width: ScreenSize.width*0.95, height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color("mediumGray"), style: StrokeStyle(lineWidth: 1.0)))
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .cornerRadius(10)
                }
            }
            
            Spacer()
                .frame(height: 15)
            
            
            /// 여행지
            Group {
                VStack(alignment: .leading) {
                    Text("여행지 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(height: 0)
                    
                    NavigationLink(destination: RegionPickerScreen(regionID: $viewModel.travelOnArray.regionId, forSort: false)) {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                                .frame(width: ScreenSize.width * 0.95, height: 36)
                                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color("mediumGray"), style: StrokeStyle(lineWidth: 1.0)))
                                .cornerRadius(10)
                                
                            
                            HStack {
                                if viewModel.travelOnArray.regionId == nil {
                                    Text("여행지 입력")
                                        .padding()
                                }
                                else {
                                    Text("\(regionViewModel.regionName)")
                                        .padding()
                                }
                                
                                Spacer()
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 15))
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 25))
                            }
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                        }
                        .onAppear {
                            if viewModel.travelOnArray.regionId != nil {
                                regionViewModel.getRegion(regionId: viewModel.travelOnArray.regionId!)
                            }
                        }
                    }
                }
            }
            
            Spacer()
                .frame(height: 10)
            
            /// 여행 출발일 · 도착일
            Group {
                HStack {
                    /// 여행 출발일
                    VStack(alignment: .leading) {
                        Text("여행 시작일")
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
                                       .frame(width: 180, height: 36)
                                       .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color("mediumGray"), style: StrokeStyle(lineWidth: 1.0)))
                                       .cornerRadius(10)
                                       
                                   
                                   HStack {
                                       Spacer()
                                           .frame(width: 10)
                                       
                                       Image("calendar")
                                           .resizable()
                                           .scaledToFit()
                                           .frame(width: 16)
                                       
                                       
                                       Text("\(dateFormat.string(from: viewModel.travelOnArray.startDate))")
                                           .font(.system(size: 14))
                                           .foregroundColor(.black)
                                   }
                               }
                           }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("여행 종료일")
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
                                       .frame(width: 180, height: 36)
                                       .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color("mediumGray"), style: StrokeStyle(lineWidth: 1.0)))
                                       .cornerRadius(10)
                                   
                                   HStack {
                                       Spacer()
                                           .frame(width: 10)
                                       
                                       Image("calendar")
                                           .resizable()
                                           .scaledToFit()
                                           .frame(width: 16)
                                       
                                       
                                       Text("\(dateFormat.string(from: viewModel.travelOnArray.endDate))")
                                           .font(.system(size: 14))
                                           .foregroundColor(.black)
                                   }
                               }
                           }
                    }
                }
                if showStartDatePicker {
                    DatePicker("", selection: $viewModel.travelOnArray.startDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: viewModel.travelOnArray.startDate, perform: { (value) in
                            showStartDatePicker = false
                        })
                        .accentColor(Color("orange"))
                        .frame(width: ScreenSize.width*0.95)
                        .background(Color.white)
                }
                
                if showEndDatePicker {
                    DatePicker("", selection: $viewModel.travelOnArray.endDate, in: viewModel.travelOnArray.startDate..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: viewModel.travelOnArray.endDate, perform: { (value) in
                            showEndDatePicker = false
                        })
                        .accentColor(Color("orange"))
                        .frame(width: ScreenSize.width*0.95)
                        .background(Color.white)
                }
            }
        }
        .padding()
        .background(.white)
    }
    
    
    // MARK: - 동행자 · 선호 숙소 · 교통수단 · 선호 음식 · 선호 음주류
    var travelInfo: some View {
        VStack(alignment: .leading) {
            /// 동행자
            VStack(alignment: .leading) {
                HStack {
                    Text("동행자 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Text("(중복선택 가능)")
                        .font(.system(size: 12))
                        .foregroundColor(Color("gray"))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            if viewModel.travelOnArray.memberSet[1] || viewModel.travelOnArray.memberSet[2] || viewModel.travelOnArray.memberSet[3] || viewModel.travelOnArray.memberSet[4] || viewModel.travelOnArray.memberSet[5] {
                                for i in 1...5 {
                                    viewModel.travelOnArray.memberSet[i] = false
                                }
                            }
                            viewModel.travelOnArray.memberSet[0].toggle()
                        }) {
                            Text("혼자")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.memberSet[0], width: 54))
                        
                        Button(action: {
                            if viewModel.travelOnArray.memberSet[0] {
                                viewModel.travelOnArray.memberSet[0] = false
                            }
                            viewModel.travelOnArray.memberSet[1].toggle()
                        }) {
                            Text("아이와")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.memberSet[1], width: 66))
                        
                        
                        Button(action: {
                            if viewModel.travelOnArray.memberSet[0] {
                                viewModel.travelOnArray.memberSet[0] = false
                            }
                            viewModel.travelOnArray.memberSet[2].toggle()
                        }) {
                            Text("부모님과")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.memberSet[2], width: 78))
                        
                        Button(action: {
                            if viewModel.travelOnArray.memberSet[0] {
                                viewModel.travelOnArray.memberSet[0] = false
                            }
                            viewModel.travelOnArray.memberSet[3].toggle()
                        }) {
                            Text("연인과")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.memberSet[3], width: 66))
                        
                        Button(action: {
                            if viewModel.travelOnArray.memberSet[0] {
                                viewModel.travelOnArray.memberSet[0] = false
                            }
                            viewModel.travelOnArray.memberSet[4].toggle()
                        }) {
                            Text("친구와")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.memberSet[4], width: 66))
                        
                        Button(action: {
                            if viewModel.travelOnArray.memberSet[0] {
                                viewModel.travelOnArray.memberSet[0] = false
                            }
                            viewModel.travelOnArray.memberSet[5].toggle()
                        }) {
                            Text("반려동물과")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.memberSet[5], width: 91))
                    }
                }
            }
            
            Spacer()
                .frame(height: 20)
            
            /// 선호 숙소
            VStack(alignment: .leading) {
                HStack {
                    Text("선호 숙소형태 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Text("(중복선택 가능)")
                        .font(.system(size: 12))
                        .foregroundColor(Color("gray"))
                    
                    Spacer()
                    
                    Menu {
                        Picker(selection: $viewModel.travelOnArray.accomPrice) {
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
                            switch viewModel.travelOnArray.accomPrice {
                            case .ten:
                                Text("10만원 이하")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("orange"))
                                
                            case .twenty:
                                Text("20만원 이하")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("orange"))
                                
                            case .thirty:
                                Text("30만원 이하")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("orange"))
                                
                            case .forty:
                                Text("40만원 이하")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("orange"))
                                
                            case .etc:
                                Text("상관없어요")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("orange"))
                                
                            default:
                                Text("가격대 선택")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("orange"))
                            }
                            
                            Spacer()
                                .frame(width: 3)
                            
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10)
                                .foregroundColor(Color("orange"))
                        }
                    }.id(viewModel.travelOnArray.accomPrice)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            if viewModel.travelOnArray.accomSet[5] {
                                viewModel.travelOnArray.accomSet[5] = false
                            }
                            viewModel.travelOnArray.accomSet[0].toggle()
                        }) {
                            Text("호텔")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.accomSet[0], width: 54))
                        
                        Button(action: {
                            if viewModel.travelOnArray.accomSet[5] {
                                viewModel.travelOnArray.accomSet[5] = false
                            }
                            viewModel.travelOnArray.accomSet[1].toggle()
                        }) {
                            Text("펜션")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.accomSet[1], width: 54))
                        
                        Button(action: {
                            if viewModel.travelOnArray.accomSet[5] {
                                viewModel.travelOnArray.accomSet[5] = false
                            }
                            viewModel.travelOnArray.accomSet[2].toggle()
                        }) {
                            Text("캠핑/글램핑")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.accomSet[2], width: 96))
                        
                        Button(action: {
                            if viewModel.travelOnArray.accomSet[5] {
                                viewModel.travelOnArray.accomSet[5] = false
                            }
                            viewModel.travelOnArray.accomSet[3].toggle()
                        }) {
                            Text("리조트")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.accomSet[3], width: 66))
                        
                        Button(action: {
                            if viewModel.travelOnArray.accomSet[5] {
                                viewModel.travelOnArray.accomSet[5] = false
                            }
                            viewModel.travelOnArray.accomSet[4].toggle()
                        }) {
                            Text("게스트하우스/민박")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.accomSet[4], width: 133))
                        
                        Button(action: {
                            if viewModel.travelOnArray.accomSet[0] || viewModel.travelOnArray.accomSet[1] || viewModel.travelOnArray.accomSet[2] || viewModel.travelOnArray.accomSet[3] || viewModel.travelOnArray.accomSet[4] {
                                for i in 0...4 {
                                    viewModel.travelOnArray.accomSet[i] = false
                                }
                            }
                            viewModel.travelOnArray.accomSet[5].toggle()
                        }) {
                            Text("숙소 어디든")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.accomSet[5], width: 93))
                    }
                }
            }
            
            Spacer()
                .frame(height: 20)
            
            /// 교통수단
            VStack(alignment: .leading) {
                Text("교통수단 선택")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                
                HStack {
                    Button(action: {
                        if viewModel.travelOnArray.transSet[1] || viewModel.travelOnArray.transSet[2] {
                            viewModel.travelOnArray.transSet[1] = false
                            viewModel.travelOnArray.transSet[2] = false
                        }
                        
                        viewModel.travelOnArray.transSet[0].toggle()
                    }) {
                        Text("자가용")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.transSet[0], width: 66))
                    
                    Button(action: {
                        if viewModel.travelOnArray.transSet[0] || viewModel.travelOnArray.transSet[2] {
                            viewModel.travelOnArray.transSet[0] = false
                            viewModel.travelOnArray.transSet[2] = false
                        }
                        
                        viewModel.travelOnArray.transSet[1].toggle()
                    }) {
                        Text("렌트카")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.transSet[1], width: 66))
                    
                    Button(action: {
                        if viewModel.travelOnArray.transSet[0] || viewModel.travelOnArray.transSet[1] {
                            viewModel.travelOnArray.transSet[0] = false
                            viewModel.travelOnArray.transSet[1] = false
                        }
                        
                        viewModel.travelOnArray.transSet[2].toggle()
                    }) {
                        Text("대중교통")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.transSet[2], width: 78))
                }
            }
            
            Spacer()
                .frame(height: 20)
            
            /// 선호 음식
            VStack(alignment: .leading) {
                HStack {
                    Text("선호 음식 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Text("(중복선택 가능)")
                        .font(.system(size: 12))
                        .foregroundColor(Color("gray"))
                }
                
                HStack {
                    Button(action: {
                        viewModel.travelOnArray.foodSet[0].toggle()
                    }) {
                        Text("한식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.foodSet[0], width: 54))
                    
                    Button(action: {
                        viewModel.travelOnArray.foodSet[1].toggle()
                    }) {
                        Text("양식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.foodSet[1], width: 54))
                    
                    Button(action: {
                        viewModel.travelOnArray.foodSet[2].toggle()
                    }) {
                        Text("중식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.foodSet[2], width: 54))
                    
                    Button(action: {
                        viewModel.travelOnArray.foodSet[3].toggle()
                    }) {
                        Text("일식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.foodSet[3], width: 54))
                    
                    Button(action: {
                        viewModel.travelOnArray.foodSet[4].toggle()
                    }) {
                        Text("세계음식")
                    }
                    .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.foodSet[4], width: 78))
                }
            }
            
            Spacer()
                .frame(height: 20)
            
            /// 선호 주류
            VStack(alignment: .leading) {
                HStack {
                    Text("선호 음주류 선택")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Text("(중복선택 가능)")
                        .font(.system(size: 12))
                        .foregroundColor(Color("gray"))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            if viewModel.travelOnArray.drinkSet[5] {
                                viewModel.travelOnArray.drinkSet[5] = false
                            }
                            viewModel.travelOnArray.drinkSet[0].toggle()
                        }) {
                            Text("소주")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.drinkSet[0], width: 54))
                        
                        Button(action: {
                            if viewModel.travelOnArray.drinkSet[5] {
                                viewModel.travelOnArray.drinkSet[5] = false
                            }
                            viewModel.travelOnArray.drinkSet[1].toggle()
                        }) {
                            Text("맥주")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.drinkSet[1], width: 54))
                        
                        Button(action: {
                            if viewModel.travelOnArray.drinkSet[5] {
                                viewModel.travelOnArray.drinkSet[5] = false
                            }
                            viewModel.travelOnArray.drinkSet[2].toggle()
                        }) {
                            Text("와인")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.drinkSet[2], width: 54))
                        
                        Button(action: {
                            if viewModel.travelOnArray.drinkSet[5] {
                                viewModel.travelOnArray.drinkSet[5] = false
                            }
                            viewModel.travelOnArray.drinkSet[3].toggle()
                        }) {
                            Text("막걸리")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.drinkSet[3], width: 66))
                        
                        Button(action: {
                            if viewModel.travelOnArray.drinkSet[5] {
                                viewModel.travelOnArray.drinkSet[5] = false
                            }
                            viewModel.travelOnArray.drinkSet[4].toggle()
                        }) {
                            Text("칵테일/양주")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.drinkSet[4], width: 96))
                        
                        Button(action: {
                            if viewModel.travelOnArray.drinkSet[0] || viewModel.travelOnArray.drinkSet[1] || viewModel.travelOnArray.drinkSet[2] || viewModel.travelOnArray.drinkSet[3] || viewModel.travelOnArray.drinkSet[4] {
                                for i in 0...4 {
                                    viewModel.travelOnArray.drinkSet[i] = false
                                }
                            }
                            viewModel.travelOnArray.drinkSet[5].toggle()
                        }) {
                            Text("음주 비선호")
                        }
                        .buttonStyle(ToggleButtonStyle(value: $viewModel.travelOnArray.drinkSet[5], width: 93))
                    }
                }
            }
        }
        .padding()
        .background(.white)
    }
    
    // MARK: - 여행 취향
    var travelType: some View {
        VStack(alignment: .leading) {
            Group {
                Text("나의 여행취향은?")
                    .font(.system(size: 14))
                
                Spacer()
                    .frame(height: 15)
                
                
                /// place type
                VStack(alignment: .leading) {
                    Text("어떤 곳을 선호하시나요?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("gray"))
                    
                    HStack {
                        Button(action: {
                            if viewModel.travelOnArray.fresh {
                                viewModel.travelOnArray.fresh = false
                            }
                            viewModel.travelOnArray.place.toggle()
                        }) {
                            if viewModel.travelOnArray.place {
                                Image("PlaceType_popular_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("PlaceType_popular_gray")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Spacer()
                            .frame(width: 12)
                        
                        Button(action: {
                            if viewModel.travelOnArray.place {
                                viewModel.travelOnArray.place = false
                            }
                            viewModel.travelOnArray.fresh.toggle()
                        }) {
                            if viewModel.travelOnArray.fresh {
                                Image("PlaceType_new_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("PlaceType_new_gray")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                    .frame(height: 20)
                
                /// activity type
                VStack(alignment: .leading) {
                    Text("어떤 여행 스타일을 선호하시나요?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("gray"))
                    
                    HStack {
                        Button(action: {
                            if viewModel.travelOnArray.lazy {
                                viewModel.travelOnArray.lazy = false
                            }
                            viewModel.travelOnArray.activity.toggle()
                        }) {
                            if viewModel.travelOnArray.activity {
                                Image("ActivityType_busy_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("ActivityType_busy_gray")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Spacer()
                            .frame(width: 12)
                        
                        Button(action: {
                            if viewModel.travelOnArray.activity {
                                viewModel.travelOnArray.activity = false
                            }
                            viewModel.travelOnArray.lazy.toggle()
                        }) {
                            if viewModel.travelOnArray.lazy {
                                Image("ActivityType_slow_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("ActivityType_slow_gray")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                    .frame(height: 20)
                
                /// sns type
                VStack(alignment: .leading) {
                    Text("SNS를 즐겨하시나요?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("gray"))
                    
                    HStack {
                        Button(action: {
                            if viewModel.travelOnArray.noSNS {
                                viewModel.travelOnArray.noSNS = false
                            }
                            viewModel.travelOnArray.sns.toggle()
                        }) {
                            if viewModel.travelOnArray.sns {
                                Image("SnsType_yes_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("SnsType_yes_gray")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Spacer()
                            .frame(width: 12)
                        
                        Button(action: {
                            if viewModel.travelOnArray.sns {
                                viewModel.travelOnArray.sns = false
                            }
                            viewModel.travelOnArray.noSNS.toggle()
                        }) {
                            if viewModel.travelOnArray.noSNS {
                                Image("SnsType_no_yellow")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                            else {
                                Image("SnsType_no_gray")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
            }
        }
        .padding()
        .background(.white)
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading){
            HStack {
                Text("상세한 요구사항을 써주세요.")
                    .font(.system(size: 14))
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 10)
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                    .frame(width: ScreenSize.width*0.95, height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color("mediumGray"), style: StrokeStyle(lineWidth: 1.0)))
                    .cornerRadius(10)
                
//                TextField("현지님이 원하시는 여행스타일, 취향을 말해주세요!", text: $viewModel.travelOnArray.description)
//                    .frame(minWidth: 0, maxWidth: 340, minHeight: 0, maxHeight: 90)
//                    .lineLimit(2)
//                    .padding()
//                    .font(.system(size: 12))
//                    .foregroundColor(Color("gray"))
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.travelOnArray.description)
                        .foregroundColor(Color("gray"))
                        .font(.system(size: 12))
                        .lineSpacing(3)
                        .lineLimit(5)
                        .background(Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255))
                        .frame(minWidth: 0, maxWidth: ScreenSize.width*0.9, minHeight: 0, maxHeight: 100)
                        .padding()
                    
                    if viewModel.travelOnArray.description == "" {
                        Text("현지님이 원하시는 여행 스타일, 취향을 말해주세요!")
                            .font(.system(size: 12))
                            .foregroundColor(Color("gray"))
                            .padding(EdgeInsets(top: 25, leading: 20, bottom: 0, trailing: 0))
                    }
                }
            }
            
        }
        .padding()
        .background(.white)
    }
}


struct TravelOnWriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnWriteScreen()
    }
}
