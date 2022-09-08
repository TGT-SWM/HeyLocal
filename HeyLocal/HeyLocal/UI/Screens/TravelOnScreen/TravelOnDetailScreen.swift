//
//  TravelOnDetailScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnDetailScreen: View {
    @StateObject var viewModel = TravelOnListScreen.ViewModel()
    
    var body: some View {
        ScrollView {
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
    }
    
    var content: some View {
        VStack {
            // Title
            Group {
                Text("\(viewModel.travelOn.title)")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
            }
            
            
            
            // Region
            Group {
                Text("\(viewModel.travelOn.region.state)")
                    .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
            }
            
            
            // When
            Group{
                VStack {
                    Text("언제")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("출발 날짜")
                        Text("\(viewModel.travelOn.modifiedDate)")
                    }
                    
                    HStack {
                        Text("종료 날짜")
                        Text("\(viewModel.travelOn.modifiedDate)")
                    }
                }
                .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
            }
            
            // With Whom
            Group {
                VStack {
                    Text("누구와")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
            }
            
            // Accomodation
            Group {
                VStack {
                    Text("숙소")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
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
            }
            
            // Food
            Group {
                VStack {
                    Text("음식")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
            }
            
            // Drink
            Group {
                VStack {
                    Text("음주")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
            }
            
            // TravelType
            Group {
                VStack {
                    Text("여행 취향")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                }
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
}

struct TravelOnDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnDetailScreen()
    }
}
