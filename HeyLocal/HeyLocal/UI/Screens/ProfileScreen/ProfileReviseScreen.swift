//
//  ProfileReviseScreen.swift
//  HeyLocal
//  사용자 프로필 수정 화면 (프로필·닉네임·주 활동지·소개 수정)
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
