//
//  OpinionWriteScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionWriteScreen: View {
    @State var moveBack: Bool = false
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
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                content
            }
        }
        .navigationTitle("답변 작성")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: writeBtn)
    }
    
    @State var description: String = ""
    @State var yesParking: Bool = false
    @State var noParking: Bool = false
    @State var yesWaiting: Bool = false
    @State var noWaiting: Bool = false
    var content: some View {
        VStack(alignment: .leading) {
            // MARK: - 장소 선택, 사진, 설명
            
            // 장소 -> NavigationLink 장소 선택
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
            
            // 사진 추가
            Button(action: {}) {
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
            
            // MARK: - 카테고리별 질문
        }
        .padding()
    }
    
    
    var common: some View {
        VStack(alignment: .leading){
            // MARK: - 공통 질문
            Group {
                Divider()
                
                Group {
                    Text("시설이 청결한가요?")
                    
                    ScrollView(.horizontal) {
                        HStack {
                            Button(action: {
                                if yesParking {
                                    yesParking.toggle()
                                }
                                noParking.toggle()
                            }) {
                                Text("없어요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                            
                            Button(action: {
                                if yesParking {
                                    yesParking.toggle()
                                }
                                noParking.toggle()
                            }) {
                                Text("없어요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                            
                            Button(action: {
                                if yesParking {
                                    yesParking.toggle()
                                }
                                noParking.toggle()
                            }) {
                                Text("없어요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                            
                            Button(action: {
                                if yesParking {
                                    yesParking.toggle()
                                }
                                noParking.toggle()
                            }) {
                                Text("없어요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                            
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
                    }
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
                }
                
                Group {
                    Text("비용이 합리적인가요?")
                    
                    ScrollView(.horizontal) {
                        HStack {
                            Button(action: {
                                if yesParking {
                                    yesParking.toggle()
                                }
                                noParking.toggle()
                            }) {
                                Text("없어요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                            
                            Button(action: {
                                if yesParking {
                                    yesParking.toggle()
                                }
                                noParking.toggle()
                            }) {
                                Text("없어요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                            
                            Button(action: {
                                if yesParking {
                                    yesParking.toggle()
                                }
                                noParking.toggle()
                            }) {
                                Text("없어요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                            
                            Button(action: {
                                if yesParking {
                                    yesParking.toggle()
                                }
                                noParking.toggle()
                            }) {
                                Text("없어요")
                            }
                            .buttonStyle(ToggleButtonStyle(value: $noParking, width: 66))
                            
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
                    }
                }
            }
            .font(.system(size: 14))
            
        }
        
    }
    
    var restaurant: some View {
        VStack {
            
        }
    }
    
    var cafe: some View {
        VStack {
            
        }
    }
}

struct OpinionWriteScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpinionWriteScreen(travelOnId: 12)
    }
}
