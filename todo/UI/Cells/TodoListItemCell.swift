import UIKit
import SnapKit

class TodoListItemCell: UICollectionViewCell {
    struct ViewModel: Hashable {
        
        var title: String? {
            listItem.title
        }
        
        var completed: Bool {
            listItem.completed
        }
        
        let listItem: ListItem
        
        init(listItem: ListItem) {
            self.listItem = listItem
        }
    }
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        
        return view
    }()
    
    private(set) lazy var checkmark: UIButton = {
        let view = UIButton()
        view.imageView?.contentMode = .scaleAspectFill
        view.contentHorizontalAlignment = .fill
        view.contentVerticalAlignment = .fill
        view.addTarget(self, action: #selector(didTapCheck), for: .touchUpInside)
        
        return view
    }()
    
    var onTapCheck: ((_ listItem: ListItem) -> Void)?
    var viewModel: ViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(checkmark, titleLabel)
        checkmark.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkmark.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        let checkTint: UIColor = viewModel.completed ? .green : .gray
        checkmark.setImage(UIImage(systemName: "checkmark")?.withTintColor(checkTint, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    @objc private func didTapCheck() {
        guard let viewModel else { return }
        onTapCheck?(viewModel.listItem)
    }
}
