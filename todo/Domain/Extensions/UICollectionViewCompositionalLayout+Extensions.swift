import UIKit

extension NSCollectionLayoutSection {
    static func singleHorizontalItemSection(estimatedHeight: CGFloat, interGroupSacing: CGFloat = 14.0) -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection.singleHorizontalItemSection(height: .estimated(estimatedHeight), interGroupSacing: interGroupSacing)
    }

    static func singleHorizontalItemSection(height: NSCollectionLayoutDimension, interGroupSacing: CGFloat = 14.0) -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: height
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSacing
        return section
    }
}
