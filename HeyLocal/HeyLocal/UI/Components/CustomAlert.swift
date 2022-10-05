//
//  CustomAlert.swift
//  HeyLocal
//  커스텀 Alert 컴포넌트
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var showingAlert: Bool
    
    var title: String
    var cancelMessage: String
    var confirmMessage: String
    var cancelWidth: Int
    var confirmWidth: Int
    var rightButtonAction: (() -> ())?
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.15)
                .edgesIgnoringSafeArea(.all)
            
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 348, height: 210)
                .cornerRadius(10)
                .shadow(color: .black, radius: 0.7)
            
            
            VStack(alignment: .center) {
                Spacer()
                    .frame(height: 15)
                
                Text("\(title)")
                    .font(.system(size: 16))
                
                Spacer()
                    .frame(height: 30)
                
                HStack {
                    // 취소 버튼 -> Dismiss
                    Button(action: {
                        showingAlert.toggle()
                    }) {
                        Text("\(cancelMessage)")
                    }
                    .buttonStyle(AlertCustomButton(value: false, width: cancelWidth))
                    
                    Spacer()
                        .frame(width: 15)
                    
                    // 확인 버튼 -> rightButtonAction
                    Button(action: {
                        rightButtonAction?()
                    }) {
                        Text("\(confirmMessage)")
                    }
                    .buttonStyle(AlertCustomButton(value: true, width: confirmWidth))
                }
            }

        }
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(showingAlert: .constant(true),
                    title: "답변작성을 취소할까요?",
                    cancelMessage: "아니요, 작성할래요",
                    confirmMessage: "네, 취소할래요",
                    cancelWidth: 134,
                    confirmWidth: 109)
    }
}
