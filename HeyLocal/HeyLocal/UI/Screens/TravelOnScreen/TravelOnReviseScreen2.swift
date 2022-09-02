//
//  TravelOnReviseScreen2.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnReviseScreen2: View {
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
    
    var body: some View {
        ScrollView {
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
            } // end of Group
            
            
            // Prev·Next Button
            Group {
                HStack {
                    // Prev Button
//                    Button(action: {
//                        firstNavLinkActive = false
//                    }, label: {
//                        Text("<   이전")
//                    })
                    
                    NavigationLink(destination: TravelOnReviseScreen1()){
                        Text("<   이전")
                    }
                    
                    Spacer()
                    
                    // Next Button
                    NavigationLink(destination: HomeScreen()){
                        Text("완료   >")
                    }
                }
            }
            .frame(width: ScreenSize.width * 0.9)
        } // end of ScrollView
    }
}

struct TravelOnReviseScreen2_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnReviseScreen2()
    }
}