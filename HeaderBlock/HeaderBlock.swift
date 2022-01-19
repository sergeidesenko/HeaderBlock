//
//  HeaderBlock.swift
//  HeaderBlock
//
//  Created by Sergey Desenko on 12.01.2022.
//

import UIKit
import SnapKit
import RxRelay

class HeaderBlock: UIView {
    let isCompact = BehaviorRelay<Bool>(value: false)
    
    var collectionHeight: CGFloat = 88
    
    private(set) lazy var categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private(set) var ideasCountLabel = UILabel()
    private(set) var rescanButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(ideasCountLabel)
        ideasCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(43)
        }
        ideasCountLabel.text = "24 / 349 ideas"
        ideasCountLabel.textColor = .black
        ideasCountLabel.font = .systemFont(ofSize: 36)
        
        self.addSubview(rescanButton)
        rescanButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10).priority(.medium)
            make.right.equalToSuperview().inset(12)
            make.size.equalTo(24)
        }
        
        self.addSubview(categoriesCollectionView)
        categoriesCollectionView.backgroundColor = .white
        categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        categoriesCollectionView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(self.collectionHeight).priority(.high)
            make.top.equalTo(ideasCountLabel.snp.bottom).offset(12)
        }
    }
}
