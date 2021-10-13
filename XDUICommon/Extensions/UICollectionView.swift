//
//  UICollectionView.swift
//  XDUICommon
//
//  Created by Timothy on 15/03/2017.
//  Copyright © 2017 xDesign. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    public func lastIndexPath() -> IndexPath? {
        let section = numberOfSections - 1
        
        if 0 > section {
            return nil
        }
        
        let row = numberOfItems(inSection: section) - 1
        
        return IndexPath(row: row, section: section)
    }

}
