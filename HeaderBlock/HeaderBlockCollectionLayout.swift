//
//  HeaderBlockCollectionLayout.swift
//  HeaderBlock
//
//  Created by Sergey Desenko on 14.01.2022.
//

import UIKit
import RxSwift
import RxRelay

class HeaderBlockCollectionLayout: UICollectionViewFlowLayout {
    let scrollOffset = BehaviorRelay<CGFloat>(value: 0.0)
    let maxCellSize = CGSize(width: 52, height: 72)
    let minCellSize = CGSize(width: 40, height: 40)
    let maxSpacing: CGFloat = 16
    let minSpacing: CGFloat = 4
    let minInset: CGFloat = 12
    let maxInset: CGFloat = 16
    let maxOffset: CGFloat = 32
    
    override func prepare() {
        super.prepare()
//        
//        let offset = min(scrollOffset.value, maxOffset)
//        let offsetFraction = (maxOffset - offset) / maxOffset
//        
//        self.minimumInteritemSpacing = minSpacing + ((maxSpacing - minSpacing) * offsetFraction)
//        self.minimumLineSpacing = minSpacing + ((maxSpacing - minSpacing) * offsetFraction)
//        
//        let leftInset = minInset + ((maxInset - minInset) * offsetFraction)
//        self.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
    }
//
//    public func calculateItemSize(for offset: CGFloat) -> CGSize {
//        let offset = min(offset, maxOffset)
//        let offsetFraction = (maxOffset - offset) / maxOffset
//
//        let cellWidth = minCellSize.width + ((maxCellSize.width - minCellSize.width) * offsetFraction)
//        let cellHeight = minCellSize.height + ((maxCellSize.height - minCellSize.height) * offsetFraction)
//
//        return CGSize(width: cellWidth, height: cellHeight)
//    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

