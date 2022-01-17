//
//  HeaderBlock.swift
//  HeaderBlock
//
//  Created by Sergey Desenko on 12.01.2022.
//

import UIKit
import SnapKit
class HeaderBlock: UICollectionReusableView {
    private(set) lazy var categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    //private(set) var collectionViewLayout = HeaderBlockCollectionLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(categoriesCollectionView)
        categoriesCollectionView.backgroundColor = .white
        categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        categoriesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
//    
//    public func setCollectionViewHeightFor(offset: CGFloat) {
//        if let layout = categoriesCollectionView.collectionViewLayout as? HeaderBlockCollectionLayout {
//            let size = layout.calculateItemSize(for: offset)
//            categoriesCollectionView.snp.remakeConstraints { make in
//                make.width.equalToSuperview()
//                make.top.bottom.equalToSuperview()
//                make.height.equalTo(size.height + 16)
//            }
//        }
//        
//    }
}
