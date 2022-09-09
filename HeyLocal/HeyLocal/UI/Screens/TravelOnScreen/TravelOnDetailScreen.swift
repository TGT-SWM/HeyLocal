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
    @State var travelOnDetail: TravelOnDetail
    
    enum Trans: String, CaseIterable {
        case ownCar = "OWN_CAR"
        case rentCar = "렌트카"
        case noCar = "대중교통"
    }
    
    var body: some View {
        ScrollView {
            Text("\(travelOnId)")
            
            content
            
            Spacer()
                .frame(height: 30)
            
            Group {
                VStack {
                    
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
                }
            }
        }
        .onAppear {
            viewModel.fetchTravelOn(travelOnId: travelOnId)
        }
        
    }
    
    
    
    var content: some View {
        VStack {
            // Title
            Group {
                Text("\(viewModel.travelOn.title!)")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
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
                    
                    switch travelOnDetail.transportationType {
                    case "OWN_CAR":
                        Text("자가용")
                    case "RENT_CAR":
                        Text("렌트카")
                    case "NO_CAR":
                        Text("대중교통")
                    default:
                        Text("")
                    }
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
                }
            }
        }
    }
    
    func fetchTravelOnDetail(travelOnId: Int) {
        viewModel.fetchTravelOn(travelOnId: travelOnId)
    }
}
//
//struct TravelOnDetailScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        TravelOnDetailScreen(travelOnId: 0)
//    }
//}


