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
                // TODO: 지역 이미지로 변경
                if travelOn.region.thumbnailUrl != nil {
                    AsyncImage(url: URL(string: travelOn.region.thumbnailUrl!)) { phash in
                        if let image = phash.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10.0)
                        }
                        else {
                            Rectangle()
                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                .cornerRadius(10.0)
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                else {
                    Rectangle()
                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        .cornerRadius(10.0)
                        .frame(width: 100, height: 100)
                }
                
                // 지역 출력
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255))
                        .cornerRadius(radius: 20.0, corners: [.bottomLeft, .bottomRight])
                        .opacity(0.5)
                        .frame(width: 100, height: 24)
     
                    HStack {
                        Image("location_white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                        
                        Text("\(regionNameFormatter(region: travelOn.region))")
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
                        Image("eye-alt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("조회수")
                            
                        Text("\(travelOn.views)")
                    }
                    
                    Spacer()
                        .frame(width: 5)
                    
                    Group {
                        Image("message-text")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                        
                        Text("답변수")
                            
                        Text("\(travelOn.opinionQuantity!)")
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(Color("gray"))
                
                Spacer()
                
                HStack {
                    let printDate = travelOn.createdDateTime.components(separatedBy: "T")
                    let yyyyMMdd = printDate[0].components(separatedBy: "-")
                    Text("\(yyyyMMdd[0]).\(yyyyMMdd[1]).\(yyyyMMdd[2])")
                    
                    Spacer()
                    
                    Group {
                        if travelOn.author.profileImgDownloadUrl == nil {
                            ZStack {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                        .frame(width: 20, height: 20)
                                        .shadow(color: .black, radius: 1)
                                    
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 13, height: 13)
                                        .foregroundColor(Color("gray"))
                                }
                                
                                Circle()
                                    .strokeBorder(.white, lineWidth: 1)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        else {
                            AsyncImage(url: URL(string: travelOn.author.profileImgDownloadUrl!)) { phash in
                                if let image = phash.image {
                                    ZStack {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .frame(width: 20, height: 20)
                                            .shadow(color: .gray, radius: 1)
                                        
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                else if phash.error != nil {
                                    ZStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                                .frame(width: 20, height: 20)
                                                .shadow(color: .black, radius: 1)
                                            
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .frame(width: 13, height: 13)
                                                .foregroundColor(Color("gray"))
                                        }
                                        
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                else {
                                    ZStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                                                .frame(width: 20, height: 20)
                                                .shadow(color: .black, radius: 1)
                                            
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .frame(width: 13, height: 13)
                                                .foregroundColor(Color("gray"))
                                        }
                                        
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                        }
                        
                        Text("\(travelOn.author.nickname)")
                        
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(Color(red: 117 / 255, green: 118 / 255, blue: 121 / 255))
            }
            .padding()
        }
        .foregroundColor(Color.black)
    }
}

// MARK: - 부분 둥근모서리 Rectangle 함수 확장
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
