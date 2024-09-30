import CoreData

class FetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
    private var onChange: () -> Void

    init(onChange: @escaping () -> Void) {
        self.onChange = onChange
        super.init()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onChange()
    }
}
