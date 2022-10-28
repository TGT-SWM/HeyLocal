//
//  PersistenceController.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import Foundation
import CoreData

// MARK: - PersistenceController

/// CoreData 사용을 위한 컨트롤러입니다.
struct PersistenceController {
	/// PersistenceController의 Singleton 객체입니다.
	static let shared = PersistenceController()
	
	/// NSPersistentContainer 객체입니다.
	let container: NSPersistentContainer
	
	private init() {
		container = NSPersistentContainer(name: "CoreDataModel")
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
	}
	
	func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
		let request = T.fetchRequest()
		let delete = NSBatchDeleteRequest(fetchRequest: request)
		
		do {
			try self.container.viewContext.execute(delete)
			return true
		} catch {
			return false
		}
	}
}
