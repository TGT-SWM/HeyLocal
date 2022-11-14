//
//  WebViewScreen.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct WebViewScreen: View {
    let url: String
    @ObservedObject var viewModel = WebViewModel()
    @Environment(\.displayTabBar) var displayTabBar
    @State var bar = true
    
    var body: some View {
        VStack {
            WebView(url: url, viewModel: viewModel)
        }
        .onReceive(self.viewModel.bar.receive(on: RunLoop.main)) { value in
            self.bar = value
        }
        .onAppear {
            displayTabBar(false)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton() )
    }
}
