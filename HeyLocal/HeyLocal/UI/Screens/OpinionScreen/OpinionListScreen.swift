//
//  OpinionListScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct OpinionListScreen: View {
    @StateObject var viewModel = OpinionComponent.ViewModel()
    @State var destination: String? = ""
    var travelOnId: Int
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.opinions) { opinion in
                ZStack(alignment: .bottomTrailing) {
//                    NavigationLink(destination: OpinionDetailScreen(travelOnId: travelOnId, opinionId: opinion.id)) {
//                        OpinionComponent(opinion: opinion)
//                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 30))
//                    }
                    
                    Button(action: {
                        destination = "\(opinion.id)"
                    }) {
                        OpinionComponent(opinion: opinion)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 30))
                    }
                    NavigationLink(destination: OpinionDetailScreen(travelOnId: travelOnId, opinionId: opinion.id), tag: "\(opinion.id)", selection: $destination) {
                        EmptyView()
                    }
                    
                    
					NavigationLink(destination: PlanSelectScreen()) {
                        ZStack {
                            Rectangle()
                                .fill(Color(red: 255/255, green: 153/255, blue: 0/255))
                                .frame(width: 90, height: 24)
                                .cornerRadius(14)
                            
                            HStack(alignment: .center) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 13)
                                    .foregroundColor(Color.white)
                                
                                Text("플랜에 추가")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.white)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
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
