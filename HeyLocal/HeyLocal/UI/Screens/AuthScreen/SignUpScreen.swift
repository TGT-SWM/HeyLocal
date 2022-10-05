//
//  SignUpScreen.swift
//  HeyLocal
//  회원가입 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct SignUpScreen: View {
    @State private var user_id: String = ""
    @State private var user_pwd: String = ""
    @State private var user_nickname: String = ""
    
    var body: some View {
        VStack {
            // Title
            Text("회원가입")
                .font(.title)
                .fontWeight(.bold)
            
            // ID · PWD · NickName
            Group {
                VStack {
                    
                    VStack {
                        Text("아이디")
                            .fontWeight(.bold)
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                            
                        
                        Spacer()
                            .frame(height: 3)
                        
                        HStack{
                            TextField("", text: $user_id)
                                .frame(width: ScreenSize.width * 0.6, height: ScreenSize.height * 0.05)
                                .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                            
                            Spacer()
                                .frame(width: 10)
                            
                            Button(action: {
                                
                            }, label: {
                                Text("중복확인")
                            })
                            .buttonStyle(BasicButtonStyle())
                        }
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    }
                    
                    // PASSWORD
                    VStack{
                        Text("비밀번호")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                        
                        Spacer()
                            .frame(height: 3)
                        
                        HStack{
                            SecureField("", text: $user_pwd)
                                .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.05)
                                .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        }
                        .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                    }
                    
                    // NICK NAME
                    VStack{
                        Text("닉네임")
                            .fontWeight(.bold)
                            .frame(maxWidth: ScreenSize.width * 0.9, alignment: .leading)
                        
                        Spacer()
                            .frame(height: 3)
                        
                        HStack{
                            TextField("", text: $user_nickname)
                                .frame(width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.05)
                                .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                        }
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("회원가입")
                    })
                    .buttonStyle(BasicButtonStyle())
                    
                    Spacer()
                        .frame(height: 20)
                }
            }
            content
        } // end of VStack
    }
    
    var content: some View {
        VStack {
            Divider()
            Spacer()
                .frame(height: 15)
            
            VStack (alignment: .leading){
                Text ("SNS 아이디를 이용해서 현지야 회원으로 가입합니다.")
                    .font(.system(size:14))
                
                Spacer()
                    .frame(height: 5)
                
                Text ("SNS 계정 회원가입")
                    .fontWeight(.bold)
            }
            .frame(width: 350)
            
            Spacer()
                .frame(height: 20)
            
            VStack {
                // KAKAO
                Button(action: {
                }, label: {
                    HStack{
                        Image("kakao_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                        Text("계정으로 회원가입")
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
                        Text("계정으로 회원가입")
                    }
                }).buttonStyle(SNSButtonStyle())
            }
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
