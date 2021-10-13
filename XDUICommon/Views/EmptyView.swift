//
//  EmptyView.swift
//  XDUICommon
//
//  Created by Timothy on 11/10/2017.
//  Copyright © 2017 xDesign. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
    
    private func privateInit() {
        backgroundColor = .white

        let label = UILabel()
        label.text = "Nothing to display"
        label.sizeToFit()

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
