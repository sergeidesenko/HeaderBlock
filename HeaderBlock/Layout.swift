//
//  Layout.swift
//  Cell Animations
//
//  Created by Christian Noon on 10/29/15.
//  Copyright © 2015 Noondev. All rights reserved.
//

import UIKit

class Layout: UICollectionViewFlowLayout {

    // MARK: - Properties

    var previousAttributes: [UICollectionViewLayoutAttributes] = []
    var currentAttributes: [UICollectionViewLayoutAttributes] = []

    var contentSize = CGSize.zero
    var isCompact = false
    var minCellSize = CGSize(width: 44, height: 54)
    var maxCellSize = CGSize(width: 68, height: 88)

    // MARK: - Preparation

    override func prepare() {
        super.prepare()

        previousAttributes = currentAttributes

        contentSize = CGSize.zero
        currentAttributes = []

        if let collectionView = collectionView {
            let itemCount = collectionView.numberOfItems(inSection: 0)
            let width: CGFloat = isCompact ? minCellSize.width : maxCellSize.width
            let height: CGFloat = isCompact ? minCellSize.height : maxCellSize.height
            var x: CGFloat = 0

            for itemIndex in 0..<itemCount {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let size = CGSize(
                    width: width,
                    height: height
                )

                attributes.frame = CGRect(x: x, y: 0, width: size.width, height: size.height)

                currentAttributes.append(attributes)

                x += size.width
            }

            contentSize = CGSize(width: x, height: height)
        }
        
        if previousAttributes.isEmpty {
            previousAttributes = currentAttributes
        }
    }

    // MARK: - Layout Attributes

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return previousAttributes[itemIndexPath.item]
    }

    override func layoutAttributesForItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return currentAttributes[itemIndexPath.item]
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForItem(at: itemIndexPath)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return currentAttributes.filter { rect.intersects($0.frame) }
    }

    // MARK: - Invalidation

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = collectionView?.bounds, !oldBounds.size.equalTo(newBounds.size) {
            return true
        }

        return false
    }

    // MARK: - Collection View Info
    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if isCompact {
            let itemsCountOffset = proposedContentOffset.x / maxCellSize.width
            let newContentOffset = itemsCountOffset * minCellSize.width
            return CGPoint(x: newContentOffset, y: 0)
        } else {
            let itemsCountOffset = proposedContentOffset.x / minCellSize.width
            let newContentOffset = itemsCountOffset * maxCellSize.width
            return CGPoint(x: newContentOffset, y: 0)
        }
    }
}
