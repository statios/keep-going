//
//  ViewController.swift
//  KeepGoing
//
//  Created by stat on 2022/12/08.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout.init(
            sectionProvider: { sectionIndex, environment in
                
                let isHorizontalCompact = environment.traitCollection.horizontalSizeClass == .compact
                
                let itemWidth: NSCollectionLayoutDimension = isHorizontalCompact ? .fractionalWidth(1.0) : .absolute(320)
                let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = .init(leading: .flexible(8), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(128))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                let headerWidth: NSCollectionLayoutDimension = isHorizontalCompact
                ? .fractionalWidth(1.0)
                : .absolute(environment.container.effectiveContentSize.width - itemWidth.dimension)
                
                let headerHeight: NSCollectionLayoutDimension = isHorizontalCompact
                ? .absolute(415)
                : .absolute(environment.container.effectiveContentSize.height)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .topLeading)
                
                if isHorizontalCompact {
                    section.contentInsets.top = .zero
                }
                else {
                    header.pinToVisibleBounds = true
                    header.zIndex = 2
                    section.contentInsets.top = -environment.container.effectiveContentSize.height
                }
                
                section.boundarySupplementaryItems = [header]
                
                return section
            },
            configuration: configuration
        )
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionViewDataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.contentView.backgroundColor = .random
            return cell
        })
        
        collectionViewDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: "header", for: indexPath)
            header.backgroundColor = .red.withAlphaComponent(0.5)
            header.layer.borderColor = UIColor.blue.cgColor
            header.layer.borderWidth = 4
            return header
        }
        
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["main"])
        snapshot.appendItems((0...100).map { _ in UUID().uuidString })
        collectionViewDataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: .random(in: 0...1))
    }
}
