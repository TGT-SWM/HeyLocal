//
//  TravelOnListScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct TravelOnListScreen: View {
    enum SortType: Int, CaseIterable, Identifiable {
        case byDate = 0
        case byViews = 1
        case byComments = 2
        
        var id: Int { self.rawValue }
    }
    
    @State private var showCommentOnly = false
    @State private var showNonCommentOnly = false
    @State private var sortedType: Int = 0
    @State private var user_id: String = ""
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack{
                    Picker("정렬 방법", selection: $sortedType) {
                        ForEach(SortType.allCases) { s in
                            switch s {
                            case .byDate:
                                Text("최신순")
                                
                            case .byViews:
                                Text("조회순")
                                
                            case .byComments:
                                Text("답변 많은 순")
                            }
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
                        TravelOnList(showCommentOnly: $showCommentOnly, showNonCommentOnly: $showNonCommentOnly, sortedType: $sortedType, user_id: $user_id)
                        
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
