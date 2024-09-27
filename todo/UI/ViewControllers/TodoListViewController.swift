import UIKit

class TodoListViewController: UIViewController {

    let viewModel: TodoListViewModel
    init() {
        viewModel = TodoListViewModel(TodoListState(APIProvider()))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    
        viewModel.viewDidLoad()
    }
}

