//
//  TableViewController.swift
//  XDUICommon
//
//  Created by Timothy on 12/03/2017.
//  Copyright © 2017 xDesign. All rights reserved.
//

import UIKit

open class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    open var displayItems: [SectionDisplayItem] = []
    
    private let style: UITableView.Style
    
    private lazy var tableViewController: UITableViewController = {
        let temp = UITableViewController(style: self.style)
        temp.tableView.delegate = self
        temp.tableView.dataSource = self
        temp.tableView.tableFooterView = UIView()
        temp.tableView.backgroundView = UIView(frame: CGRect(x: 0, y: 0,
                                                             width: self.view.bounds.width,
                                                             height: self.view.bounds.height))
        self.view.addSubview(temp.tableView)
        return temp
    }()
    
    private lazy var emptyView: UIView = {
        let temp = EmptyView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.isHidden = true
        self.tableView.backgroundView?.addSubview(temp)

        temp.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        return temp
    }()

    public var tableView: UITableView {
        return tableViewController.tableView
    }
    
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
    
    lazy var loadingFooterView: LoadingFooterView = {
        return LoadingFooterView(frame: CGRect(origin: CGPoint.zero,
                                               size: CGSize(width: 0, height: 50)))
    }()
    
    public init(style: UITableView.Style) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.style = .grouped
        super.init(nibName: nil, bundle: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupTable()
        tableView.reloadData()
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return displayItems.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard displayItems[safe: section] != nil else { return 0 }
        return displayItems[section].rowDisplayItems.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayItem = displayItems[indexPath.section].rowDisplayItems[indexPath.row]
        return configuredTableViewCell(for: displayItem, at: indexPath)
    }

    /**
     Optionally override this method to set custom constraints for the tableview.
     */
    open func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    /**
     Override this method to use a custom loading view.
     
     - Parameter show: Show or hide the loading view.
     */
    open func showLoading(_ show: Bool) {
        tableView.tableFooterView = show ? loadingFooterView : UIView()
    }

    /**
     Override this method to use a custom empty view.
     
     - Parameter show: Show or hide the empty view.
     */
    open func showEmpty(_ show: Bool) {
        tableView.backgroundView?.bringSubviewToFront(emptyView)
        emptyView.isHidden = !show
    }

    /**
     Used to register cell types and configure tableview appearance.
     
     - important: Must be overriden in subclasses.
     */
    @objc open func setupTable() {
        preconditionFailure("setupTable method should be overridden in subclass")
    }

}

extension TableViewController: TableViewInput {

    open func reload() {
        tableView.reloadData()
    }
    
    open func insertSection(_ section: SectionDisplayItem, atIndex index: Int) {
        guard index <= tableView.numberOfSections
            else { print("Section index greater than possible index (\(self.tableView.numberOfSections))"); return }
        
        var indexPaths: [IndexPath] = []
        for i in 0..<section.rowDisplayItems.count {
            indexPaths.append(IndexPath(row: i, section: index))
        }
        
        tableView.beginUpdates()
        displayItems.insert(section, at: index)
        tableView.insertSections(IndexSet(integer: index), with: .fade)
        tableView.insertRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
    }
    
    open func removeSection(_ index: Int) {
        guard displayItems[safe: index] != nil || index < tableView.numberOfSections
            else { print("Index to remove (\(index)) does not exist"); return }

        tableView.beginUpdates()
        displayItems.remove(at: index)
        tableView.deleteSections(IndexSet(integer: index), with: .fade)
        tableView.endUpdates()
    }
    
    open func insertDisplayItem(_ item: Any, atRow row: Int, inSection section: Int) {
        insertDisplayItems([item], atRow: row, inSection: section)
    }
    
    open func insertDisplayItems(_ items: [Any], atRow row: Int, inSection section: Int) {
        guard displayItems[safe: section] != nil
            else { print("Section \(section) does not exist"); return }
        
        guard row <= tableView.numberOfRows(inSection: section)
            else { print("Row exceeds number of rows (\(self.tableView.numberOfRows(inSection: section)))"); return }
        
        var indexPaths: [IndexPath] = []
        for i in 0..<items.count {
            indexPaths.append(IndexPath(row: row + i, section: section))
        }
        
        tableView.beginUpdates()
        displayItems[section].rowDisplayItems.insert(contentsOf: items, at: row)
        tableView.insertRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
    }
    
    open func appendDisplayItem(_ item: Any, toSection section: Int) {
        appendDisplayItems([item], toSection: section)
    }
    
    open func appendDisplayItems(_ items: [Any], toSection section: Int) {
        guard displayItems[safe: section] != nil
            else { print("Section \(section) does not exist"); return }
        
        var indexPaths: [IndexPath] = []
        let startIndex = tableView.numberOfRows(inSection: section)
        for i in 0..<items.count {
            indexPaths.append(IndexPath(row: startIndex + i, section: section))
        }
        
        tableView.beginUpdates()
        displayItems[section].rowDisplayItems.append(contentsOf: items)
        tableView.insertRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
    }
    
    open func removeDisplayItem(atRow row: Int, inSection section: Int) {
        guard displayItems[safe: section]?.rowDisplayItems[safe: row] != nil
            else { print("Section \(section) row \(row) does not exist"); return }
        
        tableView.beginUpdates()
        displayItems[section].rowDisplayItems.remove(at: row)
        tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .fade)
        tableView.endUpdates()
    }

    /**
     Used to create tableview cells.
     
     - important: Must be overriden in subclasses.
     */
    @objc open func configuredTableViewCell(for displayItem: Any, at indexPath: IndexPath) -> UITableViewCell {
        preconditionFailure("configuredTableViewCell method should be overridden in subclass")
    }

}

extension TableViewController {
    
    public func dequeueReusableCell<T: UITableViewCell>(for type: T.Type, at indexPath: IndexPath) -> T {
        if let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier(), for: indexPath) as? T {
            return cell
        }
        fatalError("Couldn't cast cell to \(type)")
    }
    
    public func registerNib<T: UITableViewCell>(for type: T.Type) {
        tableView.register(T.nib(), forCellReuseIdentifier: T.reuseIdentifier())
    }
    
    public func registerClass<T: UITableViewCell>(for type: T.Type) {
        tableView.register(T.self, forCellReuseIdentifier: T.reuseIdentifier())
    }
    
}
