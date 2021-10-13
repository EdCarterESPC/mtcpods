//
//  UIView.swift
//  XDUICommon
//
//  Created by Timothy on 06/03/2017.
//  Copyright © 2017 xDesign. All rights reserved.
//

import UIKit

extension UIView {

    public class func viewWithDerivedNibName() -> Self {
        if let view = viewFromNib(for: self) {
            return view
        } else {
            fatalError("Can't load view from nib for type \(self)")
        }
    }
    
    private class func viewFromNib<T: UIView>(for type: T.Type) -> T? {
        let bundle = Bundle(for: self)
        if bundle.path(forResource: className(), ofType: "nib") != nil {
            return bundle.loadNibNamed(className(), owner: nil, options: nil)?.last as? T
        }
        return nil
    }
    
    public static func nib() -> UINib {
        return UINib(nibName: self.className(), bundle: nil)
    }
    
    public static func reuseIdentifier() -> String {
        return self.className()
    }
    
    public func closestSuperviewWithClassName(_ className: String) -> UIView? {
        var view = superview
        
        while nil != view && false == view!.isKind(of: NSClassFromString(className)!) {
            view = view?.superview
        }
        
        if nil != view && true == view!.isKind(of: NSClassFromString(className)!) {
            return view!
        }
        
        return nil
    }

}
