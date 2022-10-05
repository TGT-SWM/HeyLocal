//
//  TravelOnComponent.swift
//  HeyLocal
//  여행On 컴포넌트 뷰 (여행On 리스트 조회 시 사용)
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnComponent: View {
    var travelOn: TravelOn
    
    var body: some View {
        HStack{
            /// 이미지 + 지역
            ZStack(alignment: .bottomLeading) {
                // TODO: 이미지로 변경
                Rectangle()
                    .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                    .cornerRadius(10.0)
                    .frame(width: 100, height: 100)
                
                // 지역 출력
                ZStack {
                    Rectangle()
                        .fill(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255))
                        .cornerRadius(radius: 20.0, corners: [.bottomLeft, .bottomRight])
                        .opacity(0.5)
                        .frame(width: 100, height: 24)
     
                    HStack {
                        Image("pin_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                        
                        Text("\(travelOn.region.state)")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
                    }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
            
            /// 타이틀
            VStack(alignment: .leading) {
                Text("\(travelOn.title)")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                
                Spacer()
                    .frame(height: 10)
                
                HStack(alignment: .bottom, spacing: 3) {
                    Group {
                        Image("view_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("조회수")
                            .foregroundColor(Color(red: 121 / 255, green: 119 / 255, blue: 117 / 255))
                        Text("\(travelOn.views)")
                    }
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Group {
                        Image("comment_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("답변수")
                            .foregroundColor(Color(red: 121 / 255, green: 119 / 255, blue: 117 / 255))
                        Text("\(travelOn.opinionQuantity)")
                    }
                }
                .font(.system(size: 12))
                
                Spacer()
                
                HStack {
                    let printDate = travelOn.modifiedDate.components(separatedBy: "T")
                    let yyyymmdd = printDate[0].components(separatedBy: "-")
                    Text("\(yyyymmdd[0]).\(yyyymmdd[1]).\(yyyymmdd[2])")
                    
                    Spacer()
                    
                    Group {
                        ZStack {
                            Circle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .frame(width: 20, height: 20)
                                .shadow(color: .black, radius: 1)
                                
                            
                            Circle()
                                .strokeBorder(.white, lineWidth: 1)
                                .frame(width: 20, height: 20)
                        }
                        Text("\(travelOn.user.nickname)")
                        
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(Color(red: 117 / 255, green: 118 / 255, blue: 121 / 255))
            }
            .frame(width: 200, height: 90, alignment: .topLeading)
            .padding()
        }
        .foregroundColor(Color.black)
    }
}

// MARK: 부분 둥근 Rectangle
struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
