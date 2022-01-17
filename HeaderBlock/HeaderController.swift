//
//  HeaderController.swift
//  HeaderBlock
//
//  Created by Sergey Desenko on 12.01.2022.
//

import UIKit
import RxRelay
import RxSwift
import Kingfisher

let test_categories: [IdeaCategory] = [
    IdeaCategory(name: "2-story House", image: Image(url: "http://api.brickit.epoch8.dev/image/6c29386e-e0ec-4b73-9966-6510de09018a?width=981", size: CGSize(width: 981.0, height: 981.0))),
    IdeaCategory(name: "Lighthouse", image: Image(url: "http://api.brickit.epoch8.dev/image/a2a44e1a-f8ae-45e7-a4e6-99c6bef2a3de?width=981", size: CGSize(width: 981.0, height: 981.0))),
    IdeaCategory(name: "Racer Car", image: Image(url: "http://api.brickit.epoch8.dev/image/08321efe-ccbb-477e-b05f-9fec44e7fed7?width=981", size: CGSize(width: 981.0, height: 981.0))),
    IdeaCategory(name: "Space Shuttle", image: Image(url: "http://api.brickit.epoch8.dev/image/84f2e8ae-5a9b-46ac-af94-c20677d7373b?width=981", size: CGSize(width: 981.0, height: 981.0))),
    IdeaCategory(name: "Bull", image: Image(url: "http://api.brickit.epoch8.dev/image/ec816f4d-da68-4021-890d-cdeb03418990?width=981", size: CGSize(width: 981.0, height: 981.0))),
    IdeaCategory(name: "Unicorn", image: Image(url: "http://api.brickit.epoch8.dev/image/4c36a55e-3896-4d0c-836b-bd9ba48beaf0?width=981", size: CGSize(width: 981.0, height: 981.0))),
    IdeaCategory(name: "Knight", image: Image(url: "http://api.brickit.epoch8.dev/image/8597402d-3331-4026-be44-9383a9ffc748?width=981", size: CGSize(width: 981.0, height: 981.0))),
    IdeaCategory(name: "Train", image: Image(url: "http://api.brickit.epoch8.dev/image/863f68fa-1164-4819-b456-3a8e925f85c2?width=981", size: CGSize(width: 981.0, height: 981.0)))
]

class HeaderController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    var header: HeaderBlock
    let scrollOffset = BehaviorRelay<CGFloat>(value: 0.0)
    let disposeBag = DisposeBag()
    var categories: [IdeaCategory] = []
    let selectedCategory = BehaviorRelay<String?>(value: nil)
    
    let minSpacing: CGFloat = 4
    let maxSpacing: CGFloat = 16
    let minInset: CGFloat = 12
    let maxInset: CGFloat = 16
    let maxOffset: CGFloat = 32
    
    init(header: HeaderBlock) {
        self.header = header
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.header.categoriesCollectionView.setCollectionViewLayout(layout, animated: false)
        self.header.categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        
        self.scrollOffset
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {[weak self] offset in
                self?.header.categoriesCollectionView.collectionViewLayout.invalidateLayout()
            })
            .disposed(by: disposeBag)
        
        self.header.categoriesCollectionView.dataSource = self
        self.header.categoriesCollectionView.delegate = self
        self.header.categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "b")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: { [weak self] in
            self?.categories = test_categories
            self?.header.categoriesCollectionView.reloadSections(IndexSet(integer: 0))
            self?.header.categoriesCollectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard categories.indices.contains(indexPath.item)
        else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "b", for: indexPath) as! CategoryCell
        let category = categories[indexPath.item]
        cell.category = category
        scrollOffset
            .asDriver(onErrorDriveWith: .empty())
            .drive(cell.scrollOffset)
            .disposed(by: disposeBag)
        
        self.selectedCategory
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { category in
                guard let category = category
                else {
                    cell.isSelectedCategory = false
                    return
                }
                
                if let name = cell.category?.name, name == category {
                    cell.isSelectedCategory = true
                } else {
                    cell.isSelectedCategory = false
                }
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell
        else { return .zero }
        
        return cell.calculateItemSize(forCollectionHeight: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let offset = min(scrollOffset.value, maxOffset)
        let offsetFraction = (maxOffset - offset) / maxOffset
    
        let spacing = minSpacing + ((maxSpacing - minSpacing) * offsetFraction)
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let offset = min(scrollOffset.value, maxOffset)
        let offsetFraction = (maxOffset - offset) / maxOffset
        
        let spacing = minSpacing + ((maxSpacing - minSpacing) * offsetFraction)
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offset = min(scrollOffset.value, maxOffset)
        let offsetFraction = (maxOffset - offset) / maxOffset
        
        let leftInset = minInset + ((maxInset - minInset) * offsetFraction)
        let insets = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell,
              let category = cell.category
        else { return }
        
        self.selectedCategory.accept(category.name)
    }
}
