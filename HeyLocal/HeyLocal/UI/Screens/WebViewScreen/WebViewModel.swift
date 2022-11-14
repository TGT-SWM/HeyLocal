//
//  WebViewModel.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

class WebViewModel: ObservableObject {
    var foo = PassthroughSubject<Bool, Never>()
    var bar = PassthroughSubject<Bool, Never>()
}
