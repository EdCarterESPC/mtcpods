//
//  LoadingTableViewFooterView.swift
//  XDUICommon
//
//  Created by Timothy on 11/10/2017.
//  Copyright © 2017 xDesign. All rights reserved.
//

import UIKit

public class LoadingFooterView: UICollectionReusableView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
    
    private func privateInit() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
