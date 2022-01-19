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
import RxCocoa

class CategoryCell: UICollectionViewCell {
    private var nameLabel = UILabel()
    private var coverImageView = UIImageView()
    private var selectionImageView = UIImageView()
    
    private(set) var disposeBag = DisposeBag()
    
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
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        selectionImageView.image = UIImage(named: "selection")
        self.addSubview(selectionImageView)
        selectionImageView.snp.makeConstraints { make in
            make.size.greaterThanOrEqualTo(40)
            make.size.lessThanOrEqualTo(52)
            make.width.equalTo(selectionImageView.snp.height)
            make.width.lessThanOrEqualToSuperview().inset(2)
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(coverImageView)
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.snp.makeConstraints { make in
            make.size.equalTo(selectionImageView.snp.size).inset(4)
            make.width.equalTo(coverImageView.snp.height)
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        self.bringSubviewToFront(selectionImageView)
        
        self.addSubview(nameLabel)
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.66
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(selectionImageView.snp.bottom).offset(6).priority(.low)
            make.top.greaterThanOrEqualTo(selectionImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(8).priority(.high)
        }
        
        setState()
    }
    
    private func animateTransition(isShrinking: Bool) {
        if isShrinking {
            UIView.animate(
                withDuration: 0.1,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    self.nameLabel.alpha = 0
                },
                completion: nil
            )
        } else {
            UIView.animate(
                withDuration: 0.1,
                delay: 0.1,
                options: .curveEaseOut,
                animations: {
                    self.nameLabel.alpha = 1
                },
                completion: nil
            )
        }
    }
    
    private func setState() {
        self.selectionImageView.isHidden = !self.isSelectedCategory
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.animateTransition(isShrinking: layoutAttributes.frame.height < 60)
        super.apply(layoutAttributes)
        layoutIfNeeded()
    }
}
