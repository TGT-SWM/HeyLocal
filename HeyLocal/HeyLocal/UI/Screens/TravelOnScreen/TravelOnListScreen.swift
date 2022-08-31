//
//  TravelOnListScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnListScreen: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    // Picker
                    HStack {
                        CheckedValue(label: "지역" )
                        
                        CheckedValue(label: "답변 있는 것만")
                            .padding()
                        
                        CheckedValue(label: "답변 없는 것만")
                    }
                    
                    ZStack {
                        TravelOnList()
                        
                        // write button
                        VStack {
                            Spacer()
                                .frame(height: 400)
                            
                            HStack {
                                Spacer()
                                
                                
                                NavigationLink(destination: TravelOnReviseScreen1()) {
                                    Text("+")
                                }
                                .buttonStyle(WriteButtonStyle())
                                
                                Spacer()
                            }
                        }
                    }
                }
            } // end of ScrollView
        } // end of NavigationView
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    } // end of View
}

struct TravelOnListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TravelOnListScreen()
    }
}
