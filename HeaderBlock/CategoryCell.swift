//
//  CategoryCell.swift
//  HeaderBlock
//
//  Created by Sergey Desenko on 12.01.2022.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift
import Kingfisher

class CategoryCell: UICollectionViewCell {
    let scrollOffset = BehaviorRelay<CGFloat>(value: 0.0)
    private(set) var nameLabel = UILabel()
    private(set) var coverImageView = UIImageView()
    private(set) var selectionImageView = UIImageView()
    private var maxCellSize = CGSize(width: 52, height: 72)
    private var minCellSize = CGSize(width: 40, height: 40)
    let maxOffset: CGFloat = 32
    var disposeBag = DisposeBag()
    var category: IdeaCategory? {
        didSet {
            guard let category = category else {
                return
            }

            nameLabel.text = category.name
            let url = URL(string: category.image.url)
            coverImageView.kf.setImage(with: url)
        }
    }
    var isSelectedCategory: Bool = false {
        didSet {
            self.setState()
        }
    }
    
    override func prepareForReuse() {
        isSelectedCategory = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionImageView.image = UIImage(named: "selection")
        self.addSubview(selectionImageView)
        selectionImageView.snp.makeConstraints { make in
            make.size.greaterThanOrEqualTo(minCellSize.width)
            make.size.lessThanOrEqualTo(maxCellSize.width)
            make.width.equalTo(selectionImageView.snp.height)
            make.width.lessThanOrEqualToSuperview()
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(coverImageView)
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.snp.makeConstraints { make in
            make.size.equalTo(selectionImageView.snp.size).inset(4)
            make.width.equalTo(coverImageView.snp.height)
            make.top.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
        }
        
        self.bringSubviewToFront(selectionImageView)
        
        self.addSubview(nameLabel)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.66
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(selectionImageView.snp.bottom).offset(6).priority(.medium)
            make.left.right.bottom.equalToSuperview().priority(.medium)
        }
        
        setState()
    }
    
    public func calculateItemSize(for offset: CGFloat) -> CGSize {
        let offset = min(offset, maxOffset)
        let offsetFraction = (maxOffset - offset) / maxOffset
        
        let cellWidth = minCellSize.width + ((maxCellSize.width - minCellSize.width) * offsetFraction)
        let cellHeight = minCellSize.height + ((maxCellSize.height - minCellSize.height) * offsetFraction)
        
        return CGSize(width: floor(cellWidth), height: floor(cellHeight))
    }
    
    public func calculateItemSize(forCollectionHeight height: CGFloat) -> CGSize {
        let cellHeight = height - 16
        let heightFraction = cellHeight / maxCellSize.height
        
        let labelWidth = nameLabel.intrinsicContentSize.width
        if labelWidth > maxCellSize.width {
            maxCellSize = CGSize(width: labelWidth, height: maxCellSize.height)
        }
        
        let cellWidth = maxCellSize.width * heightFraction
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override var intrinsicContentSize: CGSize {
        let labelWidth = nameLabel.intrinsicContentSize.width
        if labelWidth > maxCellSize.width {
            maxCellSize = CGSize(width: labelWidth, height: maxCellSize.height)
        }
        let desiredSize = calculateItemSize(for: scrollOffset.value)
        return desiredSize
    }
    
    private func setState() {
        self.selectionImageView.isHidden = !self.isSelectedCategory
    }
//    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
//        layoutAttributes.size = self.intrinsicContentSize
//        return layoutAttributes
//    }
}
