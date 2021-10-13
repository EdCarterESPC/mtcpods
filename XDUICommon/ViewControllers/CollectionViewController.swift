//
//  CollectionViewController.swift
//  XDUICommon
//
//  Created by Timothy on 14/03/2017.
//  Copyright © 2017 xDesign. All rights reserved.
//

import UIKit

open class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    open var displayItems: [SectionDisplayItem] = []

    /**
     Show loading indicator.
     
     - important: Override showLoading(_ show: Bool) to use custom view.
     */
    public var isLoading: Bool = false {
        didSet {
            showLoading(isLoading)
        }
    }
    
    /**
     Show empty view.
     
     - important: Override showEmpty(_ show: Bool) to use custom view.
     */
    public var isEmpty: Bool = false {
        didSet {
            showEmpty(isEmpty)
        }
    }
    
    private lazy var collectionViewController: UICollectionViewController = {
        let temp = UICollectionViewController(collectionViewLayout: UICollectionViewLayout())
        temp.collectionView?.dataSource = self
        temp.collectionView?.delegate = self
        
        guard let collectionView = temp.collectionView else { fatalError("unable to create collectionview!") }
        self.view.addSubview(collectionView)
        return temp
    }()
    
    public var collectionView: UICollectionView {
        if let temp = collectionViewController.collectionView {
            return temp
        }
        fatalError("collectionView is nil!")
    }
    
    private lazy var emptyView: UIView = {
        let temp = EmptyView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isHidden = true
        self.view.addSubview(temp)
        
        temp.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        return temp
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        privateSetupCollectionView()
        setupCollectionView()
    }
    
    /**
     Optionally override this method to set custom constraints for the collectionview.
     */
    open func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func privateSetupCollectionView() {
        collectionView.register(LoadingFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: LoadingFooterView.reuseIdentifier())
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return displayItems.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayItems[section].rowDisplayItems.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let displayItem = displayItems[indexPath.section].rowDisplayItems[indexPath.row]
        return configuredCollectionViewCell(for: displayItem, at: indexPath)
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                   referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading && section == collectionView.lastIndexPath()!.section {
            return CGSize(width: 0, height: 50)
        }
        
        return .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                               withReuseIdentifier: LoadingFooterView.reuseIdentifier(),
                                                               for: indexPath)
    }
    
    /**
     Override this method to use custom loading view behaviour.
     
     - Parameter show: Show or hide the loading view.
     */
    open func showLoading(_ show: Bool) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    /**
     Override this method to use a custom empty view.
     
     - Parameter show: Show or hide the empty view.
     */
    open func showEmpty(_ show: Bool) {
        emptyView.isHidden = !show
    }

    /**
     Used to register cell types and configure appearance.
     
     - important: Must be overriden in subclasses.
     */
    @objc open func setupCollectionView() {
        preconditionFailure("setupCollectionView method should be overridden in subclass")
    }
}

extension CollectionViewController: CollectionViewInput {

    public func reload() {
        collectionView.reloadData()
    }
    
    public func insertDisplayItem(_ item: Any, atRow row: Int, inSection section: Int) {
        insertDisplayItems([item], atRow: row, inSection: section)
    }
    
    public func insertDisplayItems(_ items: [Any], atRow row: Int, inSection section: Int) {
        guard displayItems[safe: section] != nil
            else { print("Section \(section) does not exist"); return }
        
        guard row <= collectionView.numberOfItems(inSection: section)
            else { print("Row exceeds number of rows (\(self.collectionView.numberOfItems(inSection: section)))"); return }
        
        var indexPaths: [IndexPath] = []
        for i in 0..<items.count {
            indexPaths.append(IndexPath(row: row + i, section: section))
        }

        collectionView.performBatchUpdates({
            self.displayItems[section].rowDisplayItems.insert(contentsOf: items, at: row)
            self.collectionView.insertItems(at: indexPaths)
        }, completion: nil)
    }
    
    public func appendDisplayItem(_ item: Any, toSection section: Int) {
        appendDisplayItems([item], toSection: section)
    }
    
    public func appendDisplayItems(_ items: [Any], toSection section: Int) {
        guard displayItems[safe: section] != nil
            else { print("Section \(section) does not exist"); return }
        
        var indexPaths: [IndexPath] = []
        let startIndex = self.collectionView.numberOfItems(inSection: section)
        for i in 0..<items.count {
            indexPaths.append(IndexPath(row: startIndex + i, section: section))
        }
        
        collectionView.performBatchUpdates({
            self.displayItems[section].rowDisplayItems.append(contentsOf: items)
            self.collectionView.insertItems(at: indexPaths)
        }, completion: nil)
    }
    
    public func removeSection(_ index: Int) {
        guard displayItems[safe: index] != nil || index < collectionView.numberOfSections
            else { print("Index to remove (\(index)) does not exist"); return }

        collectionView.performBatchUpdates({
            self.displayItems.remove(at: index)
            self.collectionView.deleteSections(IndexSet(integer: index))
        }, completion: nil)
    }
    
    public func insertSection(_ section: SectionDisplayItem, atIndex index: Int) {
        guard index <= collectionView.numberOfSections
            else { print("Section index greater than possible index (\(self.collectionView.numberOfSections))"); return }
        
        collectionView.performBatchUpdates({
            self.displayItems.insert(section, at: index)
            self.collectionView.insertSections(IndexSet(integer: index))
        }, completion: nil)
    }
    
    public func removeDisplayItem(atRow row: Int, inSection section: Int) {
        guard displayItems[safe: section]?.rowDisplayItems[safe: row] != nil
            else { print("Section \(section) row \(row) does not exist"); return }
        
        collectionView.performBatchUpdates({
            self.displayItems[section].rowDisplayItems.remove(at: row)
            self.collectionView.deleteItems(at: [IndexPath(row: row, section: section)])
        }, completion: nil)
    }
    
    /**
     Used to create collectionview cells.
     
     - important: Must be overriden in subclasses.
     */
    @objc open func configuredCollectionViewCell(for displayItem: Any, at indexPath: IndexPath) -> UICollectionViewCell {
        preconditionFailure("configuredCollectionViewCell method should be overridden in subclass")
    }

}

extension CollectionViewController {
    
    public func dequeueReusableCell<T: UICollectionViewCell>(for type: T.Type, at indexPath: IndexPath) -> T {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier(), for: indexPath) as? T {
            return cell
        }
        fatalError("couldn't cast cell to \(type)")
    }
    
    public func dequeueSupplementaryView<T: UICollectionReusableView>(for type: T.Type, indexPath: IndexPath, kind: String) -> T {
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier(), for: indexPath) as? T {
            return view
        }
        fatalError("couldn't cast reusable view to \(type)")
    }
    
}

