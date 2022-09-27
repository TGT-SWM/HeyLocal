//
//  TravelOnDetailScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnDetailScreen: View {
    @State var travelOnId: Int
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            content
            
            Spacer()
                .frame(height: 30)
            
            opinions
        }
        .onAppear {
            viewModel.fetchTravelOn(travelOnId: travelOnId)
        }
    }
    
    var content: some View {
        VStack {
            // Title
            Group {
                HStack {
                    Text("\(viewModel.travelOn.title!)")
                        .font(.system(size: 25))
                        .fontWeight(.bold)

                    Spacer()
                    
                    Button(action: {}) {
                        Text("수정")
                    }
                    
                    // 삭제 클릭 시, 팝업 창 출려
                    Button("삭제") {
                        self.showingAlert = true
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(""),
                              message: Text("정말 삭제하시겠습니까?"),
                              primaryButton: .destructive(Text("삭제"),
                                                          action: {
                            viewModel.deleteTravelOn(travelOnId: viewModel.travelOn.id!)
                        }),
                              secondaryButton: .cancel(Text("취소")))}
                }
                .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                Spacer()
                    .frame(height: 20)
            }
            
            // Region
            Group {
                Text("\(viewModel.travelOn.region!.state)")
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                
                Spacer()
                    .frame(height: 20)
            }
            
            
            // When
            Group{
                VStack {
                    Text("언제")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        Text("출발 날짜")
                        let printDate = viewModel.travelOn.travelStartDate!.components(separatedBy: "T")
                        let yyyymmdd = printDate[0].components(separatedBy: "-")
                        Text("\(yyyymmdd[0])년 \(yyyymmdd[1])월 \(yyyymmdd[2])일")
                    }
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        Text("종료 날짜")
                        let printDate = viewModel.travelOn.travelEndDate!.components(separatedBy: "T")
                        let yyyymmdd = printDate[0].components(separatedBy: "-")
                        Text("\(yyyymmdd[0])년 \(yyyymmdd[1])월 \(yyyymmdd[2])일")
                    }
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
                Spacer()
                    .frame(height: 20)
            }
            
            // With Whom
            Group {
                VStack {
                    Text("누구와")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    ForEach(viewModel.travelOn.travelMemberSet!) { member in
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                                .cornerRadius(90)
                            
                            Text("\(memToString(mem: member.type!))")
                        }
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    }
                }
            }
            
            
            // Accomodation
            Group {
                
                VStack {
                    HStack {
                        Text("숙소")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(viewModel.travelOn.accommodationMaxCost! / 10000)만원 이하") // ERROR
                    }
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
                Spacer()
                    .frame(height: 20)
                
                
                HStack {
                    ForEach(viewModel.travelOn.hopeAccommodationSet!) { accom in
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                                .cornerRadius(90)
                            
                            Text("\(accomToString(accom: accom.type!))")
                        }
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    }
                }
            }
            
            // Transportation
            Group {
                VStack {
                    Text("교통수단")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
                Spacer()
                    .frame(height: 20)
                
                
                ZStack {
                    Rectangle()
                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                        .cornerRadius(90)
                    
                    Text("\(transToString(trans: viewModel.travelOn.transportationType!))")
                }
                .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
            }
            
            // Food
            Group {
                VStack {
                    HStack {
                        Text("음식")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(viewModel.travelOn.foodMaxCost! / 10000)만원 이하")
                    }
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    ForEach(viewModel.travelOn.hopeFoodSet!) { food in
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                                .cornerRadius(90)
                            
                            Text("\(foodToString(food: food.type!))")
                        }
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    }
                }
            }
            
            // Drink
            Group {
                VStack {
                    HStack {
                        Text("음주")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("\(viewModel.travelOn.drinkMaxCost! / 10000)만원 이하")
                    }
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    
                    HStack {
                        ForEach(viewModel.travelOn.hopeDrinkSet!) { drink in
                            ZStack {
                                Rectangle()
                                    .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                    .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                                    .cornerRadius(90)
                                
                                Text("\(drinkToString(drink: drink.type!))")
                            }
                        }
                    }
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                }
                Spacer()
                    .frame(height: 20)
            }
            
            // TravelType
            Group {
                VStack {
                    Text("여행 취향")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        // 인기 있는 곳 VS 참신한 곳
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                                .cornerRadius(90)
                            
                            switch viewModel.travelOn.travelTypeGroup.placeTasteType! {
                            case "FAMOUS":
                                Text("인기 있는 곳")
                            case "FRESH":
                                Text("참신한 곳")
                            default:
                                Text("")
                            }
                        }
                        
                        // 부지런 VS 느긋한
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                                .cornerRadius(90)
                            
                            switch viewModel.travelOn.travelTypeGroup.activityTasteType! {
                            case "HARD":
                                Text("부지런")
                            case "LAZY":
                                Text("느긋한")
                            default:
                                Text("")
                            }
                        }
                        
                        // SNS 유명장소 VS SNS는 안해요
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                                .cornerRadius(90)
                            
                            switch viewModel.travelOn.travelTypeGroup.snsTasteType! {
                            case "YES":
                                Text("SNS 유명장소")
                            case "NO":
                                Text("SNS는 안해요")
                            default:
                                Text("")
                            }
                        }
                    }
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                }
                Spacer()
                    .frame(height: 20)
            }
            
            // Description
            Group {
                VStack {
                    Text("설명")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    Text(viewModel.travelOn.description!)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
            }
        }
    }
    
    var opinions: some View {
        VStack{
            HStack {
                Text("이런 곳은 어때요?")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                
                Spacer()
                    .frame(width: 3)
                
                Text("0건")
                
                Button("나도 추천해줄래요!") {
                    
                }
            }
            Divider()
            
            // TODO: 해당 여행On에 있는 답변 List 출력
        }
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
        TravelOnDetailScreen(travelOnId: 0)
    }
}


