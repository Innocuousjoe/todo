import CoreData

func createInMemoryManagedObjectContext() -> NSManagedObjectContext? {
  guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else { return nil }
  
  let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
  do {
      try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
  } catch {
      print("Error creating test core data store: \(error)")
      return nil
  }
  
  let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
  
  return managedObjectContext
}

class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "todo")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
