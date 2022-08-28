//
//  NetworkAgent.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import Combine

struct NetworkAgent {
	let session = URLSession.shared
	
	func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
		return session
			.dataTaskPublisher(for: request)
			.map(\.data)
			.decode(type: T.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}
