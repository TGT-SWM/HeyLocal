//
//  OpinionListScreen.swift
//  HeyLocal
//  답변 리스트 화면
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionListScreen: View {
    @StateObject var viewModel = OpinionComponent.ViewModel()
    var travelOnId: Int
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.opinions) { opinion in
                ZStack(alignment: .bottomTrailing) {
                    NavigationLink(destination: OpinionDetailScreen(travelOnId: travelOnId, opinionId: opinion.id)) {
                        OpinionComponent(opinion: opinion)
                    }
                    
					NavigationLink(destination: PlanSelectScreen(opinionId: opinion.id)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color("orange"))
                                .frame(width: 80, height: 32)
                            
                            Text("플랜에 추가")
                                .font(.system(size: 12))
                                .foregroundColor(Color.white)
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchOpinions(travelOnId: travelOnId, opinionId: nil)
        }
    }
}

struct OpinionListScreen_Previews: PreviewProvider {
    static var previews: some View {
        OpinionListScreen(travelOnId: 12)
    }
}
