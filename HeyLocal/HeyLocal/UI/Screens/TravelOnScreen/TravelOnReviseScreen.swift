//
//  TravelOnReviseScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//
import SwiftUI

struct TravelOnReviseScreen: View {
    @State var travel_title: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var withWhom: With = .alone
    @State var accom: Accom = .hotel
    @State var accom_price: Price = .ten
    @State var trans: Trans = .ownCar
    
    @State var favFood: [Food] = [Food.korean]
    @State var favDrink: [Drink] = [Drink.soju]
    @State var favTavel: TravelFav = .fav
    @State var foodPrice: Price = .ten
    @State var drinkPrice: Price = .ten
    @State var description: String = ""

    enum Food: String, CaseIterable {
        case korean = "한식"
        case western = "양식"
        case chinese = "중식"
        case japanese = "일식"
        case world = "세계음식"
    }
    
    enum Drink: String, CaseIterable {
        case soju = "소주"
        case beer = "맥주"
        case wine = "와인"
        case makgeolli = "막걸리"
        case cocktail = "칵테일/양주"
        case noDrink = "술 안마셔요"
    }
    
    enum TravelFav: String, CaseIterable {
        case fav = "인기 있는 곳"
        case nonFav = "참신한 곳"
        case diligent = "부지런"
        case lazy = "느긋한"
        case sns = "SNS 유명장소"
        case nonSNS = "SNS 안해요"
    }
    
    enum Price: String, CaseIterable, Identifiable {
        case ten = "10만원"
        case twenty = "20만원"
        case thirty = "30만원"
        case forty = "40만원"
        case etc = "상관 없어요"
        
        var id: String { self.rawValue }
    }
    
    enum TravelType {
        case likePopular(yes: Bool)
        case isDiligent(yes: Bool)
        case doSNS(yes: Bool)
    }
    
    
    enum With: String, CaseIterable {
        case alone = "혼자"
        case child = "아이와"
        case parent = "부모님과"
        case couple = "연인과"
        case friend = "친구와"
        case pet = "반려동물과"
    }
    
    enum Accom: String, CaseIterable {
        case hotel = "호텔"
        case pension = "펜션"
        case camping = "캠핑/글램핑"
        case guestHouse = "게스트하우스"
        case resort = "리조트"
        case etc = "상관 없어요"
    }
    
    enum Trans: String, CaseIterable {
        case ownCar = "자가용"
        case rentCar = "렌트카"
        case noCar = "대중교통"
    }
    
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월 d일"
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            // Title
            Group {
                VStack{
                    Text("여행 On 제목")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    TextField("", text: $travel_title)
                        .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.05)
                        .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                }
                Spacer()
                    .frame(height: ScreenSize.height * 0.05)
            }
            
            
            // Place
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
            
            // Who
            Group {
                VStack {
                    Text("누구와")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        CheckedValue(value: false, label: With.alone.rawValue)
                        
                        CheckedValue(value: false, label: With.child.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: With.parent.rawValue)
                    }
                    .frame(width: ScreenSize.width * 0.9)
                   
                    HStack {
                        CheckedValue(value: false, label: With.couple.rawValue)
                        
                        CheckedValue(value: false, label: With.friend.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: With.pet.rawValue)
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
                        
                        Picker("비용", selection: $accom_price){
                            ForEach(Price.allCases) { p in
                                Text(p.rawValue)
                            }
                        }
                        
                        Text("이하")
                            .font(.system(size: 20))
                        
                        
                    }
                    .frame(width: ScreenSize.width * 0.9)
                    
                    HStack {
                        CheckedValue(value: false, label: Accom.hotel.rawValue)
                        
                        CheckedValue(value: false, label: Accom.pension.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: Accom.camping.rawValue)
                    }
                    .frame(width: ScreenSize.width * 0.9)
                   
                    HStack {
                        CheckedValue(value: false, label: Accom.guestHouse.rawValue)
                        
                        CheckedValue(value: false, label: Accom.resort.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: Accom.etc.rawValue)
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
                        CheckedValue(value: false, label: Trans.ownCar.rawValue)
                        
                        CheckedValue(value: false, label: Trans.rentCar.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: Trans.noCar.rawValue)
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
                        CheckedValue(value: false, label: Food.korean.rawValue)
                        
                        CheckedValue(value: false, label: Food.western.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: Food.chinese.rawValue)
                    }
                    .frame(width: ScreenSize.width * 0.9)
                   
                    HStack {
                        CheckedValue(value: false, label: Food.japanese.rawValue)
                        
                        CheckedValue(value: false, label: Food.world.rawValue)
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
                        CheckedValue(value: false, label: Drink.soju.rawValue)
                        
                        CheckedValue(value: false, label: Drink.beer.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: Drink.wine.rawValue)
                    }
                    .frame(width: ScreenSize.width * 0.9)
                   
                    HStack {
                        CheckedValue(value: false, label: Drink.makgeolli.rawValue)
                        
                        CheckedValue(value: false, label: Drink.cocktail.rawValue)
                            .padding()
                        CheckedValue(value: false, label: Drink.noDrink.rawValue)
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
                        CheckedValue(value: false, label: TravelFav.fav.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: TravelFav.nonFav.rawValue)
                    }
                    .frame(width: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        CheckedValue(value: false, label: TravelFav.diligent.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: TravelFav.lazy.rawValue)
                    }
                    .frame(width: ScreenSize.width * 0.9, alignment: .leading)
                    
                    HStack {
                        CheckedValue(value: false, label: TravelFav.sns.rawValue)
                            .padding()
                        
                        CheckedValue(value: false, label: TravelFav.nonSNS.rawValue)
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
                
                // Next Button
                NavigationLink(destination: HomeScreen()){
                    Text("완료   >")
                }
            } // end of Group
            
            
            // Prev·Next Button
            
            
        }
    }
}

struct TravelOnReviseScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnReviseScreen()
    }
}
