//
//  IdeasCountCell.swift
//  HeaderBlock
//
//  Created by Sergey Desenko on 13.01.2022.
//

import UIKit

class IdeasCountCell: UICollectionViewCell {
    private(set) var ideasCountLabel = UILabel()
    private(set) var rescanButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .white
        self.addSubview(ideasCountLabel)
        ideasCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32).priority(UILayoutPriority(99))
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        ideasCountLabel.text = "24 / 349 ideas"
        ideasCountLabel.textColor = .black
        ideasCountLabel.font = .systemFont(ofSize: 36)
        ideasCountLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .vertical)
        ideasCountLabel.setContentCompressionResistancePriority(UILayoutPriority(100), for: .horizontal)
        
        self.addSubview(rescanButton)
        rescanButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10).priority(.medium)
            make.right.equalToSuperview().inset(12)
            make.size.equalTo(24).priority(.medium)
        }
        rescanButton.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
}
