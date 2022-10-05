//
//  SignInScreen.swift
//  HeyLocal
//  로그인 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct SignInScreen: View {
    @State private var user_id: String = ""
    @State private var user_pwd: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()    // 이미지 크기 조절
                    .scaledToFit()  // 이미지 비율 유지
                    .frame(width: 150)
                
                Group {
                    VStack{
                        VStack{
                            Text("아이디")
                                .fontWeight(.bold)
                                .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)

                            Spacer()
                                .frame(height: 3)

                            TextField("", text: $user_id)
                                .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.05)
                                .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        }

                        VStack{
                            Text("패스워드")
                                .fontWeight(.bold)
                                .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)

                            Spacer()
                                .frame(height: 3)

                            TextField("", text: $user_pwd)
                                .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.05)
                                .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        }

                        Spacer()
                            .frame(height: 20)

                        // 로그인 버튼
                        Button(action: {

                        }, label: {
                            Text("로그인")
                        })
                        .buttonStyle(BasicButtonStyle())
                    }
                    Divider()
                    Spacer()
                        .frame(height: 20)

                    
                }
                content
                
                NavigationLink("현지야 회원가입", destination: SignUpScreen())
            }
        }
    }
    
    var content: some View {
        VStack {
            VStack {
                // KAKAO
                Button(action: {
                }, label: {
                    HStack{
                        Image("kakao_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                        Text("계정으로 로그인")
                    }
                }).buttonStyle(SNSButtonStyle())
                
                // APPle
                Button(action: {
                }, label: {
                    HStack{
                        Image("apple_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                        Text("계정으로 로그인")
                    }
                }).buttonStyle(SNSButtonStyle())
            }
        }
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
