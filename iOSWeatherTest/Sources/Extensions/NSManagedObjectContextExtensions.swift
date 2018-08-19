//
//  NSManagedObjectContextExtensions.swift
//  iOSWeatherTest
//
//  Created by Dmytro Hrebeniuk on 8/19/18.
//  Copyright © 2018 Dmytro. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {

	class func managedObjectContext(atURL storageURL: URL, withModel model:NSManagedObjectModel) throws -> NSManagedObjectContext {
		let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		
		let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		do {
			try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storageURL, options: nil)
		}
		catch {
			try? FileManager.default.removeItem(at: storageURL)
			try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storageURL, options: nil)
		}
		managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
		
		return managedObjectContext
	}
	
	
	
	/** Fetch object with keys and values */
	func fetchManagedObject(entityName entity: String, uniqueItems: [(key: String, value: NSObject)]) throws -> NSManagedObject? {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		request.resultType = NSFetchRequestResultType()
		
		var predicates = [NSPredicate]()
		for uniqueItem in uniqueItems {
			predicates.append(NSPredicate(format: "\(uniqueItem.key) = %@", uniqueItem.value))
		}
		request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		request.fetchLimit = 1
		let results = try self.fetch(request)
		
		return results.first as? NSManagedObject
	}
	
	/** Fetch object with key and value */
	func fetchManagedObject(entityName entity: String, uniqueKey: String, uniqueValue: NSObject) throws -> NSManagedObject? {
		return try self.fetchManagedObject(entityName: entity, uniqueItems: [(key: uniqueKey, value: uniqueValue)])
	}
	
	/** Create FetchResults Controller for current ManagerContext */
	func fetchResultsController(entityName entity:String, sortDescriptors: [NSSortDescriptor]? = nil,  section sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<NSFetchRequestResult> {
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		fetchRequest.sortDescriptors = sortDescriptors
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
		
		return fetchedResultsController
	}
	
}
