//
//  ContentView.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var authManager = AuthManager.shared
	
	init() {
		authManager.fetch()
	}
	
    var body: some View {
		if authManager.authorized == nil {
			SignInScreen()
		} else {
			Main()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
