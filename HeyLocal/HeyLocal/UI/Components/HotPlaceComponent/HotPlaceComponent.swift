//
//  HotPlaceComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct HotPlaceComponent: View {
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                // 장소 이미지
                Rectangle()
                    .fill(Color("lightGray"))
                    .frame(width: 208, height: 208)
                    .cornerRadius(10)
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 208, height: 208)
                    .cornerRadius(10)
                    .opacity(0.2)
                
                //
                VStack {
                    // 지역 이름
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.black)
                            .frame(width: 64, height: 20)
                        
                        HStack{
                            Spacer()
                                .frame(width: 5)
                            Text("부산광역시")
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    // 장소 이름
                    Text("더 클리프")
                        .foregroundColor(Color.white)
                        .font(.system(size: 14))
                }
                .padding()
            }
        }
    }
}

struct HotPlaceComponent_Previews: PreviewProvider {
    static var previews: some View {
        HotPlaceComponent()
    }
}
