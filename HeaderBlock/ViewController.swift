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
    let layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private lazy var headerBlock = HeaderBlock(frame: .zero)
    private lazy var statusBarView = UIView()
    private var headerController: HeaderController?
    
    let ideasCountViewHeight: CGFloat = 88
    let maxHeaderHeight: CGFloat = 88
    let minHeaderHeight: CGFloat = 54
    var topInset: CGFloat = 0
    var maxHeaderOffset: CGFloat = 0
    var minHeaderOffset: CGFloat = 0
    var topInsetConstraint: ConstraintMakerEditable?
    
    let isCompact = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }

    private func setupView() {
        view.backgroundColor = .white
        self.view.addSubview(headerBlock)
        topInset = UIApplication.shared.windows[0].safeAreaInsets.top
        minHeaderOffset = topInset
        maxHeaderOffset = topInset - ideasCountViewHeight
        headerBlock.snp.makeConstraints { make in
            topInsetConstraint = make.top.equalToSuperview().inset(topInset)
            make.left.right.equalToSuperview()
        }
        self.headerController = HeaderController(header: headerBlock)
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerBlock.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "a")
        collectionView.contentInsetAdjustmentBehavior = .never
        
        self.setupStatusBar()
    }
    
    private func setupBindings() {
        collectionView.rx.contentOffset
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {[weak self] point in
                guard let self = self else { return }
                self.updateHeader(for: point.y)
            })
            .disposed(by: disposeBag)
        
        isCompact
            .skip(1)
            .asDriver(onErrorDriveWith: .empty())
            .distinctUntilChanged()
            .drive(onNext: {[weak self] isCompact in
                self?.headerController?.isCompact.accept(isCompact)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupStatusBar() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarHeight)
        }
        
        statusBarView.backgroundColor = .white
    }
    
    private func updateHeader(for offset: CGFloat) {
        if offset > 0 && topInset > maxHeaderOffset {
            DispatchQueue.main.async {
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
            
            topInset -= offset
            topInsetConstraint?.constraint.update(inset: max(self.topInset, self.maxHeaderOffset))
            if self.topInset <= self.maxHeaderOffset {
                self.isCompact.accept(true)
            }
        }
        else if offset < 0 {
            DispatchQueue.main.async {
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
            if topInset < minHeaderOffset {
                topInset -= offset
                
                topInsetConstraint?.constraint.update(inset: min(self.topInset, self.minHeaderOffset))
                if self.topInset >= self.maxHeaderOffset {
                    self.isCompact.accept(false)
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "a", for: indexPath)
        cell.backgroundColor = .orange
        return cell
    }
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

//misc
extension UIApplication {
    var statusBarHeight: CGFloat {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .compactMap {
                $0.statusBarManager
            }
            .map {
                $0.statusBarFrame
            }
            .map(\.height)
            .max() ?? 0
    }
}
