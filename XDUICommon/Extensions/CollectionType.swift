//
//  CollectionType.swift
//  XDUICommon
//
//  Created by Timothy Brand-Spencer on 21/10/2016.
//  Copyright © 2016 xDesign. All rights reserved.
//

extension Collection {
    
    public subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
