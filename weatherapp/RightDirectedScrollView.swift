//
//  RightDirectedScrollView.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

class RightDirectedScrollView: UIScrollView {
    override var contentSize: CGSize {
        didSet {
            guard contentSize != CGSize.zero else { return }
            resetIntialContentOffset()
        }
    }

    private func resetIntialContentOffset() {
        setContentOffset(CGPoint(x: contentSize.width - bounds.size.width, y: 0), animated: false)
    }
}
