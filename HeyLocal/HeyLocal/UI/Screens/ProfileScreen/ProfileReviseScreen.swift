//
//  ProfileReviseScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileReviseScreen: View {
    @Binding var navLinkActive: Bool
    var body: some View {
        VStack {
            Group {
                Text(" USER IMAGE ")
            }
            
            Group {
                Text(" USER NICKNAME ")
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
//
//struct ProfileReviseScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileReviseScreen()
//    }
//}
