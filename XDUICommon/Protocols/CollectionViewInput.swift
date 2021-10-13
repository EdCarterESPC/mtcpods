//
//  CollectionViewInput.swift
//  XDUICommon
//
//  Created by Timothy on 14/03/2017.
//  Copyright © 2017 xDesign. All rights reserved.
//

import UIKit

public protocol CollectionViewInput: class {
    var displayItems: [SectionDisplayItem] { get set }
    var isLoading: Bool { get set }
    var isEmpty: Bool { get set }

    func reload()
    func insertDisplayItem(_ item: Any, atRow row: Int, inSection section: Int)
    func insertDisplayItems(_ items: [Any], atRow row: Int, inSection section: Int)
    func appendDisplayItem(_ item: Any, toSection section: Int)
    func appendDisplayItems(_ items: [Any], toSection section: Int)
    func removeDisplayItem(atRow row: Int, inSection section: Int)
    func insertSection(_ section: SectionDisplayItem, atIndex index: Int)
    func removeSection(_ index: Int)
    func configuredCollectionViewCell(for displayItem: Any, at indexPath: IndexPath) -> UICollectionViewCell
}
