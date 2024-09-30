import UIKit
import SnapKit

class TodoListItemCell: UICollectionViewCell {
    struct ViewModel: Hashable {
        
        var title: String? {
            listItem.title
        }
        
        private let listItem: ListItem
        
        init(listItem: ListItem) {
            self.listItem = listItem
        }
    }
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ viewModel: ViewModel) {
        titleLabel.text = viewModel.title
    }
}
