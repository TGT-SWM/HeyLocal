//
//  TravelOnListScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnListScreen: View {
    enum Category: String, CaseIterable, Identifiable {
        case recent = "최신순"
        case manyViews = "조회순"
        case manyComments = "많은 답변순"
        
        var id: String { self.rawValue }
    }
    
    @State var ceee: Category = .recent
    
    
    @State private var showCommentOnly = false
    @State private var showNonCommentOnly = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack{
                    Picker("정렬", selection: $ceee){
                        ForEach(Category.allCases) { c in
                            Text(c.rawValue)
                        }
                    }
                    // Picker
                    HStack(spacing: 0) {
                        CheckedValue(value: false, label: "지역" )
                        
                        CheckedValued(value: $showCommentOnly, label: "답변 있는 것만")
                            .padding()
                        
                        CheckedValued(value: $showNonCommentOnly, label: "답변 없는 것만")
                    }
                    
                    // TravelOnLists · WriteButton
                    ZStack {
                        TravelOnList(showCommentOnly: $showCommentOnly, showNonCommentOnly: $showNonCommentOnly)
                        
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: TravelOnReviseScreen1()) {
                                Text("+")
                            }                            .buttonStyle(WriteButtonStyle())
                                .offset(y: -130)
                                .frame(height: ScreenSize.height * 0.7, alignment: .bottom)
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
