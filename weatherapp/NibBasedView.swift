//
//  NibBasedView.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/17/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

protocol NibBasedView {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension NibBasedView where Self: UIView {
    static var nibName: String {
        return "\(self)"
    }

    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: self.nibName, bundle: bundle)
    }
}

extension NibBasedView where Self: UIView {
    static func instantiateFromNib() -> Self? {
        return nib.instantiate(withOwner: nil, options: nil).filter { (result) -> Bool in
            return (result as? Self) != nil
        }.first as? Self
    }
}
