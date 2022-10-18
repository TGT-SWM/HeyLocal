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
    @Environment(\.dismiss) private var dismiss
    
    var title: String                   // Alert창 Message
    var cancelMessage: String           // 왼쪽 버튼 Message
    var confirmMessage: String          // 오른쪽 버튼 Message
    var cancelWidth: Int                // 왼쪽 버튼 길이
    var confirmWidth: Int               // 오른쪽 버튼 길이
    var rightButtonAction: (() -> ())?  // 오른쪽 버튼 클릭 시 실행할 함수
    var destinationView: AnyView?       // 오른쪽 버튼 클릭 시 함수 실행 후 이동할 화면
    
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
                    NavigationLink(destination: destinationView){
                        Text("\(confirmMessage)")
                    }.simultaneousGesture(TapGesture().onEnded{
                        rightButtonAction?()
                        dismiss()
                    })
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
