//
//  OpinionStyle.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionStyle: View {
    var label: String = "네네"
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 34)
                .overlay(RoundedRectangle(cornerRadius: 100.0).strokeBorder(Color(red: 255/255, green: 153/255, blue: 0/255), style: StrokeStyle(lineWidth: 1.0)))
            
            Text("\(label)")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }.fixedSize()
    }
}


struct OpinionStyle_Previews: PreviewProvider {
    static var previews: some View {
        OpinionStyle(label: "네")
    }
}
