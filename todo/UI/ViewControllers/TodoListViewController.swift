import UIKit
import SnapKit

class TodoListViewController: UIViewController {

    private(set) lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    private(set) lazy var layout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex, environment) in
            let sectionItem = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            return self.layout(for: sectionItem)
        }
        
        return layout
    }()
    
    private(set) lazy var dataSource: UICollectionViewDiffableDataSource<TodoListViewModel.Section, TodoListViewModel.Item> = {
        let itemCellReg = UICollectionView.CellRegistration<TodoListItemCell, TodoListItemCell.ViewModel> { [weak self] (cell, indexPath, viewModel) in
            
            cell.configure(viewModel)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<TodoListViewModel.Section, TodoListViewModel.Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .item(viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: itemCellReg,
                    for: indexPath,
                    item: viewModel
                )
            }
        }
        
        return dataSource
    }()
    
    let viewModel: TodoListViewModel
    init() {
        viewModel = TodoListViewModel(TodoListState(APIProvider()))
        super.init(nibName: nil, bundle: nil)
        
        let homeImage = UIImageView(image: UIImage(named: "homethrive")?.withRenderingMode(.alwaysOriginal))
        homeImage.snp.makeConstraints { $0.size.equalTo(24) }
        let leftBar = UIBarButtonItem(customView: homeImage)
        navigationItem.leftBarButtonItem = leftBar
        
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain, 
            target: self,
            action: #selector(didTapAdd)
        )
        navigationItem.rightBarButtonItem = addButton
        
        UINavigationBar.appearance().backgroundColor = .white
        
        navigationItem.title = "To Do"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
    @objc private func didTapAdd() {
        
    }
    
    //MARK: Private
    private func layout(for section: TodoListViewModel.Section) -> NSCollectionLayoutSection {
        switch section {
        case .listItems:
            return .singleHorizontalItemSection(estimatedHeight: 50)
        }
    }
}

