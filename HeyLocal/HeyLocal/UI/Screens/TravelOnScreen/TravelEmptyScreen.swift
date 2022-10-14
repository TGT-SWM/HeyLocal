//
//  TravelEmptyScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelEmptyScreen: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color(red: 236/255, green: 236/255, blue: 236/255)
                    .ignoresSafeArea()
            
            VStack {
                Text("이런, 작성된 여행On이 없어요")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                
                Text("여행On을 작성해볼까요?")
            }
            .font(.system(size: 14))
            .foregroundColor(Color(red: 121/255, green: 119/255, blue: 117/255))
        }
        .padding()
    }
}

struct TravelEmptyScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelEmptyScreen()
    }
}
