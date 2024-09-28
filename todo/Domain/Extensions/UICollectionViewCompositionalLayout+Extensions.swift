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
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSacing
        return section
    }

    static func twoColumnHorizontalItemSection(rowHeight: CGFloat, itemSpacing: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(rowHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(itemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        return section
    }
}
