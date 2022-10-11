//
//  OpinionDetailScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionDetailScreen: View {
    // custom Back button
    @Environment(\.dismiss) private var dismiss
    var btnBack : some View { Button(action: {
        dismiss()
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .foregroundColor(.black)
        }
    }
    
    // Navigation Bar Item : 수정·삭제 ActionSheet 보기
    @State var showingSheet = false
    @State var showingAlert = false
    @State var navigationLinkActive = false
    var moreBtn: some View {
        Button(action: {
            showingSheet.toggle()
        }) {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .frame(width: 14)
                .foregroundColor(.black)
                .rotationEffect(.degrees(-90))
        }
        .confirmationDialog("", isPresented: $showingSheet, titleVisibility: .hidden) { //actionsheet
             Button("게시글 수정") {
                 navigationLinkActive = true
             }
             Button("삭제", role: .destructive) {
                 showingAlert.toggle()
             }
             Button("취소", role: .cancel) {
             }
        }
    }
    
    @StateObject var viewModel = OpinionComponent.ViewModel()
    var travelOnId: Int
    var opinionId: Int
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                ScrollView {
                    content
                }
                
                user
            }
        }
        .onAppear {
//            viewModel.fetchOpinion(travelOnId: travelOnId, opinionId: opinionId)
        }
        .navigationTitle("답변 상세")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: moreBtn)
    }
    
    
    var content: some View {
        VStack(alignment: .leading) {
            // MARK: - 장소명, 시간, region, 사진, description
            Group {
                Text("해운대 해수욕장")
                    .font(.system(size: 16))
                
                HStack {
                    Text("2022.09.13")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 117/255, green: 118/255, blue: 121/255))
                    
                    HStack {
                        Image("pin_black_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Spacer()
                            .frame(width: 3)
                        
                        Text("부산 해운대구 우동")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                    }
                }
                
                
                // TODO: 이미지
                
                Text("해수욕장이랑 물품 보관함이랑 꽤나 가까웠어요, 도보로 5분이 안걸려요. 가격도 저렵해서 만족스러웠어요.")
                    .font(.system(size: 14))
            }
            
            Divider()
            
            // 공통 질문
            common
            
            // 카테고리별 질문
            switch viewModel.opinion.place.category {
            case "FD6":
                food
                
            case "CE7":
                cafe
                
            case "CT1":
                sightseeing
                
            case "AT4":
                sightseeing
                
            case "AD5":
                accommodation
            
                
            default:
                Text("")
            }
        }
    }
    
    // MARK: - 장소 및 답변 기본 정보
    var information: some View {
        VStack {
            
        }
    }
    
    // MARK: - '기타' · '공통' 답변
    var common: some View {
        VStack(alignment: .leading) {
            Group {
                Text("어떤 점이 좋았나요?")
                    .font(.system(size: 16))
                
                
                Text("✨ 청결도")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                OpinionStyle(label: "시설이 청결해요")
                
                Text("🔧 시설")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                OpinionStyle(label: "주차장이 있어요")
                
                Text("💰 비용")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
                HStack {
                    OpinionStyle(label: "가격이 합리적이에요")
                    OpinionStyle(label: "웨이팅이 없어요")
                }
            }
        }
    }
    
    // MARK: - '음식점' 답변
    var food: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("추가의견")
                .font(.system(size: 16))
            
            Text("가게 분위기는 어떤가요")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "쓴맛")
            
            
            Text("추천하는 메뉴는 무엇인가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "쓴맛")
            
            
        }
    }
    
    // MARK: - '카페' 답변
    var cafe: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("추가의견")
                .font(.system(size: 16))
            
            Text("커피 스타일은 어떤가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "쓴맛")
            
            
            Text("추천하는 음료·디저트는 무엇인가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "쓴맛")
            
            Text("카페 분위기는 어떤가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "힙해요")
            
            
        }
    }
    
    // MARK: - '문화시설' · '관광명소' 답변
    var sightseeing: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("추가의견")
                .font(.system(size: 16))
            
            Text("여기서 꼭 해봐야 하는 게 있나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "아니요")
            
            Text("여기서 추천하는 간식이 있나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "아니요")
            
            Text("여기의 사진 명소는 어디인가요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "아니요")
        }
    }
    
    // MARK: - '숙박' 답변
    var accommodation: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("추가의견")
                .font(.system(size: 16))
            
            Text("주변이 시끄럽나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "아니요")
            
            Text("방음이 잘 되나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "네")
            Text("조식이 나오나요?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
            OpinionStyle(label: "네")
        }
    }
    
    
    
    // MARK: - 작성자 정보
    var user: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(red: 85/255, green: 85/255, blue: 85/255))
                .frame(width: ScreenSize.width, height: 136)
            
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .frame(width: 56, height: 56)
                    
                    Spacer()
                        .frame(width: 15)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("부산광역시")
                            .font(.system(size: 12))
                        
                        Text("김현지")
                            .font(.system(size: 16))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 3) {
                            Image("comment_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                            
                            Text("답변수")
                            Text("189")
                        }
                        
                        HStack(alignment: .center, spacing: 3) {
                            Image("heart_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                            
                            Text("채택수")
                            Text("845")
                        }
                    }
                    .font(.system(size: 12))
                }
                
                Spacer()
                    .frame(height: 15)
                
                Text("안녕하세요, 부산사는 김현지입니다 ^0^*")
                    .font(.system(size: 12))
                
            } // vstack
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
            .foregroundColor(Color.white)
        } // zstack
    } // user
}

struct OpinionDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpinionDetailScreen(travelOnId: 0, opinionId: 0)
    }
}
