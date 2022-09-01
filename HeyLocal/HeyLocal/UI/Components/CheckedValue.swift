//
//  CheckedValue.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct CheckedValue: View {
    @State var value: Bool = false
    let label: String
    
    init (value: Bool, label: String) {
        self.value = value
        self.label = label
    }
    
    var body: some View {
        Button(action: {
            self.value.toggle()
            print(self.value.description)
        }) {
            ZStack {
                Rectangle()
                    .fill(value ? Color(red: 255 / 255, green: 209 / 255, blue: 120 / 255) : Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                    .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                    .cornerRadius(90)
                
                Text(label)
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                
            }
        }
    }
}

struct CheckedValued: View {
    @Binding var value:Bool
    var label: String = ""
    
    var body: some View {
        Button(action: {
            self.value.toggle()
        }) {
            ZStack {
                Rectangle()
                    .fill(value ? Color(red: 255 / 255, green: 209 / 255, blue: 120 / 255) : Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                    .frame(width: ScreenSize.width * 0.26, height: ScreenSize.height * 0.05)
                    .cornerRadius(90)
                
                Text(label)
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                
            }
        }
    }
}
