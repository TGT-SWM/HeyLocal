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
    @Binding var showingReportAlert: Bool
    @Binding var navigationLinkActive: Bool
    
    let authId: Int
    
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
            if authId == AuthManager.shared.authorized!.id {
                Button("수정") {
                    navigationLinkActive = true
                }
                Button("삭제", role: .destructive) {
                    showingAlert = true
                }
                Button("취소", role: .cancel) {
                }
            }
            else {
                Button("게시글 신고", role: .destructive) {
                    showingReportAlert.toggle()
                }
                Button("취소", role: .cancel) {
                }
            }
        }
    }
}
