import UIKit
import SnapKit

class PageHeader: UIView {
    private(set) lazy var label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        
        return view
    }()
    
    private(set) lazy var selectionBar: UIView = {
        let view = UIView()
        view.snp.makeConstraints { $0.height.equalTo(4) }
        
        return view
    }()
    
    var onTap: (() -> Void)?

    var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .black : .gray
            selectionBar.backgroundColor = isSelected ? .black : .gray
        }
    }
    
    init(_ title: String, selected: Bool) {
        isSelected = selected
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews(label, selectionBar)
        label.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        selectionBar.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(5)
            make.leading.bottom.trailing.equalToSuperview()
        }
        label.text = title
        label.textColor = selected ? .black : .gray
        selectionBar.backgroundColor = selected ? .black : .gray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTap() {
        guard !isSelected else { return }
        isSelected.toggle()
        onTap?()
    }
}
