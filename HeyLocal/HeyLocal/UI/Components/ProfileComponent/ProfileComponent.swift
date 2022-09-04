//
//  ProfileComponent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ProfileComponent: View {
    var body: some View {
        ZStack {
            Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255)
            
            VStack {
                HStack {
                    // User Image
                    Group {
                        WebImage(url: "https://cdna.artstation.com/p/assets/images/images/034/457/380/large/shin-min-jeong-.jpg?1612345128")
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
                                Text("김현지")
                                    .font(.system(size: 23))
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                                .frame(height: 15)
                            
                            HStack {
                                Text("노하우")
                                    .fontWeight(.semibold)
                                Text("500하우")
                            }
                            
                            Spacer()
                                .frame(height: 5)
                            
                            HStack {
                                Text("랭킹")
                                    .fontWeight(.semibold)
                                Text("350위")
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
        ProfileComponent()
    }
}