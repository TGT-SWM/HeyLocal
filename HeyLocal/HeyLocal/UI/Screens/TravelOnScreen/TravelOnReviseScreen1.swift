//
//  TravelOnReviseScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI


struct TravelOnReviseScreen1: View {
    @State var travel_title: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var withWhom: With = .alone
    @State var accom: Accom = .hotel
    @State var accom_price: Price = .ten
    @State var trans: Trans = .ownCar
    
    
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
    
    enum Price: String, CaseIterable, Identifiable {
        case ten = "10만원"
        case twenty = "20만원"
        case thirty = "30만원"
        case forty = "40만원"
        case etc = "상관 없어요"
        
        var id: String { self.rawValue }
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
        NavigationView {
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
                            CheckedValue(id: With.alone.rawValue, label: With.alone.rawValue)
                            
                            CheckedValue(id: With.child.rawValue, label: With.child.rawValue)
                                .padding()
                            
                            CheckedValue(id: With.parent.rawValue, label: With.parent.rawValue)
                        }
                        .frame(width: ScreenSize.width * 0.9)
                       
                        HStack {
                            CheckedValue(id: With.couple.rawValue, label: With.couple.rawValue)
                            
                            CheckedValue(id: With.friend.rawValue, label: With.friend.rawValue)
                                .padding()
                            
                            CheckedValue(id: With.pet.rawValue, label: With.pet.rawValue)
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
                            CheckedValue(id: Accom.hotel.rawValue, label: Accom.hotel.rawValue)
                            
                            CheckedValue(id: Accom.pension.rawValue, label: Accom.pension.rawValue)
                                .padding()
                            
                            CheckedValue(id: Accom.camping.rawValue, label: Accom.camping.rawValue)
                        }
                        .frame(width: ScreenSize.width * 0.9)
                       
                        HStack {
                            CheckedValue(id: Accom.guestHouse.rawValue, label: Accom.guestHouse.rawValue)
                            
                            CheckedValue(id: With.friend.rawValue, label: With.friend.rawValue)
                                .padding()
                            
                            CheckedValue(id: With.pet.rawValue, label: With.pet.rawValue)
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
                            CheckedValue(id: Trans.ownCar.rawValue, label: Trans.ownCar.rawValue)
                            
                            CheckedValue(id: Trans.rentCar.rawValue, label: Trans.rentCar.rawValue)
                                .padding()
                            
                            CheckedValue(id: Trans.noCar.rawValue, label: Trans.noCar.rawValue)
                        }
                        .frame(width: ScreenSize.width * 0.9)
                    }
                    
                } // end of Group
                
                
                // Next Button
                NavigationLink(destination: HomeScreen()){
                    Text("다음   >")
                }
            } // end of ScrollView
        } // end of NavigationView
    }
}

struct CheckedValue: View {
    let id: String
    let label: String
    
    init (id: String, label: String) {
        self.id = id
        self.label = label
    }
    
    @State var isMarked: Bool = false
    var body: some View {
        Button(action: {
            self.isMarked.toggle()
        }) {
            ZStack {
                Rectangle()
                    .fill(isMarked ? Color(red: 255 / 255, green: 209 / 255, blue: 120 / 255) : Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                    .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                    .cornerRadius(90)
                
                Text(label)
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                
            }
        }
    }
}


struct TravelOnReviseScreen1_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnReviseScreen1()
    }
}
