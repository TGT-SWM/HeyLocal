//
//  ProfileReviseScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileReviseScreen: View {
    @Binding var navLinkActive: Bool
    @Binding var nickname: String
    
    var body: some View {
        VStack {
            Group {
                Text(" USER IMAGE ")
            }
            
            Group {
                Text(" \(nickname) ")
                TextField("", text: $nickname)
            }
            
            Group {
                HStack {
                    Button(action: {
                        navLinkActive = false
                    }, label: {
                        Text("취소")
                    })
                    
                    Button(action: {}) {
                        Text("확인")
                    }
                }
            }
        }
    }
}

struct ProfileReviseScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileReviseScreen(navLinkActive: .constant(true), nickname: .constant("dd"))
    }
}
