//
//  ProfileComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileComponent: View {
    @State var user: User
    
    var body: some View {
        ZStack {
            Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
            
            VStack {
                HStack {
                    // User Image
                    Group {
                        WebImage(url: user.imageUrl)
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(.infinity)
                    }
                    
                    Spacer()
                        .frame(width: 30)
                    
                    // User Information
                    Group {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(user.nickname)")
                                    .font(.system(size: 23))
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                                .frame(height: 15)
                            
                            HStack {
                                Text("노하우")
                                    .fontWeight(.semibold)
                                Text("\(user.knowHow)하우")
                            }
                            
                            Spacer()
                                .frame(height: 5)
                            
                            HStack {
                                Text("랭킹")
                                    .fontWeight(.semibold)
//                                Text("\(user.ranking)위")
                            }
                        } // end of VStack
                    } // end of Group
                } // end of HStack
            } // end of VStack
            .frame(width: ScreenSize.width * 0.8, alignment: .leading)
        } // end of ZStack
        .frame(height: ScreenSize.height * 0.2)
    }
}

struct ProfileComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileComponent(user: User(nickname: "김현지", imageUrl: "", knowHow: 100, ranking: 20))
    }
}
