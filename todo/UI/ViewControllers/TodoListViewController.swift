import UIKit
import SnapKit

class TodoListViewController: UIViewController {

    private(set) lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    private(set) lazy var layout: UICollectionViewCompositionalLayout = { [weak self] in
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        guard let self else { return .list(using: config) }
        
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            var actions: [UIContextualAction] = []
            if case let .item(itemCellViewModel) = self?.dataSource.itemIdentifier(for: indexPath) {
                let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, completion in
                    self?.viewModel.deleteItem(itemCellViewModel.listItem, completion: completion)
                })
                actions.append(deleteAction)
            }
            
            return .init(actions: actions)
        }
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }()
    
    private(set) lazy var dataSource: UICollectionViewDiffableDataSource<TodoListViewModel.Section, TodoListViewModel.Item> = {
        let itemCellReg = UICollectionView.CellRegistration<TodoListItemCell, TodoListItemCell.ViewModel> { [weak self] (cell, indexPath, viewModel) in
            
            cell.onTapLabel = { listItem in
                self?.didTapAddOrEdit(listItem)
            }
            cell.onTapCheck = { listItem in
                self?.viewModel.toggleCheck(listItem)
            }
            cell.configure(viewModel)
        }
        
        let addTaskReg = UICollectionView.CellRegistration<TodoListAddItemCell, Void> { [weak self] (cell, indexPath, viewModel) in
            
            cell.onTap = {
                self?.didTapAddOrEdit()
            }
        }
        
        let dataSource = UICollectionViewDiffableDataSource<TodoListViewModel.Section, TodoListViewModel.Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .item(viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: itemCellReg,
                    for: indexPath,
                    item: viewModel
                )
            case .addItem:
                return collectionView.dequeueConfiguredReusableCell(
                    using: addTaskReg, 
                    for: indexPath,
                    item: ()
                )
            }
        }
        
        return dataSource
    }()
    
    private(set) lazy var activeTab: PageHeader = {
        let view = PageHeader("Active", selected: true)
        
        view.onTap = { [weak self] in
            self?.completedTab.isSelected = false
            self?.allTab.isSelected = false
            self?.viewModel.didTapNewPage(.active)
        }
        return view
    }()
    
    private(set) lazy var completedTab: PageHeader = {
        let view = PageHeader("Completed", selected: false)

        view.onTap = { [weak self] in
            self?.activeTab.isSelected = false
            self?.allTab.isSelected = false
            self?.viewModel.didTapNewPage(.completed)
        }
        return view
    }()
    
    private(set) lazy var allTab: PageHeader = {
        let view = PageHeader("All", selected: false)

        view.onTap = { [weak self] in
            self?.completedTab.isSelected = false
            self?.activeTab.isSelected = false
            self?.viewModel.didTapNewPage(.all)
        }
        
        return view
    }()
    
    private(set) lazy var headerWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubviews(activeTab, completedTab, allTab)
        activeTab.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        completedTab.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        allTab.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        return view
    }()
    
    let viewModel: TodoListViewModel
    init() {
        viewModel = TodoListViewModel(TodoListState(APIProvider()))
        super.init(nibName: nil, bundle: nil)
        
        let homeImage = UIImageView(image: UIImage(named: "homethrive")?.withRenderingMode(.alwaysOriginal))
        homeImage.snp.makeConstraints { $0.size.equalTo(24) }
        let leftBar = UIBarButtonItem(customView: homeImage)
        navigationItem.leftBarButtonItem = leftBar
        
        UINavigationBar.appearance().backgroundColor = .white
        
        navigationItem.title = "To Do"
        
        view.addSubviews(headerWrapper,collectionView)
        headerWrapper.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerWrapper.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel.onSnapshotUpdate = { [weak self] snapshot in
            self?.dataSource.apply(snapshot)
        }
        
        viewModel.viewDidLoad()
    }
    
    //MARK: Selectors
    @objc private func didTapAddOrEdit(_ listItem: ListItem? = nil) {
        let title: String
        let message: String
        var textFieldText: String? = ""
        if let listItem {
            title = "Edit Task"
            message = "Update task title"
            textFieldText = listItem.title
        } else {
            title = "New Task"
            message = "Add a task"
        }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
          [unowned self] action in
                                        
          guard let textField = alert.textFields?.first,
                let nameToSave = textField.text, nameToSave.count > 0 else {
              return
          }

            self.viewModel.addOrUpdate(nameToSave, listItem: listItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textField in
            textField.text = textFieldText
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: Private
    private func layout(for section: TodoListViewModel.Section) -> NSCollectionLayoutSection {
        switch section {
        case .listItems:
            return .singleHorizontalItemSection(estimatedHeight: 50)
        }
    }
}

