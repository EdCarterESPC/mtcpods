//
//  NSObject.swift
//  XDUICommon
//
//  Created by Timothy on 06/03/2017.
//  Copyright © 2017 xDesign. All rights reserved.
//

import UIKit

extension NSObject {
    
    static func className() -> String {
        
        let className = NSStringFromClass(self)
        let sanitizedClassName = className.components(separatedBy: ".").last!
        
        do {
            let regularExpression = try NSRegularExpression(pattern: "[0-9]", options: NSRegularExpression.Options())
            let stop = "!"
            let range = NSMakeRange(0, sanitizedClassName.count)
            let modified = regularExpression.stringByReplacingMatches(in: sanitizedClassName,
                                                                      options: NSRegularExpression.MatchingOptions(), range: range, withTemplate: stop)
            
            return modified.components(separatedBy: stop).last!
        } catch {
            
        }
        
        return sanitizedClassName
    }

}
