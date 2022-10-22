//
//  MoreButton.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct MoreButton: View {
    @Binding var showingSheet: Bool
    @Binding var showingAlert: Bool
    @Binding var navigationLinkActive: Bool
    
    var body: some View {
        Button(action: {
            showingSheet.toggle()
        }) {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .frame(width: 14)
                .foregroundColor(.black)
                .rotationEffect(.degrees(-90))
        }
        .confirmationDialog("", isPresented: $showingSheet, titleVisibility: .hidden) { //actionsheet
             Button("수정") {
                 navigationLinkActive = true
             }
             Button("삭제", role: .destructive) {
                 showingAlert = true
             }
             Button("취소", role: .cancel) {
             }
        }
    }
}
