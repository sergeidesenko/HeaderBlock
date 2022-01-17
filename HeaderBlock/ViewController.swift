//
//  ViewController.swift
//  HeaderBlock
//
//  Created by Sergey Desenko on 12.01.2022.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    let layout = UICollectionViewFlowLayout()
    let maxHeaderHeight: CGFloat = 88
    let minHeaderHeight: CGFloat = 56
    let maxHeaderOffset: CGFloat = 120
    let IdeasCountCellHeight: CGFloat = 88
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        
        layout.scrollDirection = .vertical
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.left.right.bottom.equalToSuperview()
        }
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "a")
        collectionView.register(IdeasCountCell.self, forCellWithReuseIdentifier: "c")
        collectionView.register(HeaderBlock.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "aa")
        
        layout.sectionHeadersPinToVisibleBounds = true

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.rx.contentOffset
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {[weak self] point in
                if point.y <= 0 {
                    DispatchQueue.main.async {
                        self?.collectionView.contentOffset = CGPoint(x: 0, y: 0)
                    }
                }
                
                self?.collectionView.collectionViewLayout.invalidateLayout()
            })
            .disposed(by: disposeBag)
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 15
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c", for: indexPath)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "a", for: indexPath)
            cell.backgroundColor = .orange
            return cell
        default:
            return UICollectionViewCell()
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width, height: IdeasCountCellHeight)
        case 1:
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        default:
            return .zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let offset = max(min(collectionView.contentOffset.y, maxHeaderOffset) - IdeasCountCellHeight, 0)
        let maxHeaderOffset = maxHeaderOffset - IdeasCountCellHeight
        let height = minHeaderHeight + (maxHeaderHeight - minHeaderHeight) * (maxHeaderOffset - offset) / maxHeaderOffset
        
        switch section {
        case 0:
            return .zero
        case 1:
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 1 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "aa", for: indexPath) as! HeaderBlock
            let headerController = HeaderController(header: headerView)
            let cellOffset = IdeasCountCellHeight
            collectionView.rx.contentOffset
                .asDriver()
                .drive(onNext: { point in
                    headerController.scrollOffset.accept(max(point.y - cellOffset, 0))
                })
                .disposed(by: disposeBag)
            
            headerView.categoriesCollectionView.collectionViewLayout.invalidateLayout()
            return headerView
        }
        return UICollectionReusableView()
    }
    
}

