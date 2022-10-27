//
//  AuthManager.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class AuthManager: ObservableObject {
	static let shared = AuthManager()
	
	let context = PersistenceController.shared.container.viewContext
	
	@Published var authorized: Auth?
	
	var accessToken: String {
		if let auth = authorized {
			return auth.accessToken
		} else {
			return ""
		}
	}
	
	private init() {}
	
	func fetch() {
		var data: [Authorization] = []
		
		do {
			data = try context.fetch(Authorization.fetchRequest()) as! [Authorization]
		} catch {
			print(error.localizedDescription)
		}
		
		if !data.isEmpty {
			authorized = Auth.from(data[0])
		}
	}
	
	func save(_ auth: Auth) {
		// Entity 가져오기
		let entity = NSEntityDescription.entity(forEntityName: "Authorization", in: context)
		
		if let entity = entity {
			// NSManagedObject 객체 만들기
			let authorization = NSManagedObject(entity: entity, insertInto: context)
			authorization.setValue(auth.id, forKey: "id")
			authorization.setValue(auth.accountId, forKey: "accountId")
			authorization.setValue(auth.nickname, forKey: "nickname")
			authorization.setValue(auth.userRole, forKey: "userRole")
			authorization.setValue(auth.accessToken, forKey: "accessToken")
			authorization.setValue(auth.refreshToken, forKey: "refreshToken")
			
			// 저장
			do {
				try self.context.save()
				authorized = auth
			} catch {
				print(error.localizedDescription)
			}
		}
	}
	
	func removeAll() {
		let request = Authorization.fetchRequest()
		if PersistenceController.shared.deleteAll(request: request) {
			authorized = nil
		}
	}
}
