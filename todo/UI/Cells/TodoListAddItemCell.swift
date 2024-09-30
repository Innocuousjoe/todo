import UIKit
import SnapKit

class TodoListAddItemCell: UICollectionViewCell {
    private(set) lazy var plus: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "plus")?.withTintColor(.gray, renderingMode: .alwaysOriginal))
        
        return view
    }()
    
    private(set) lazy var addLabel: UILabel = {
        let view = UILabel()
        view.text = "Add task"
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(plus, addLabel)
        plus.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        addLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(plus.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
