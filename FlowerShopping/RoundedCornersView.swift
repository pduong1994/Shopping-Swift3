//
//  RoundedCornersView.swift
//  FlowerShopping
//
//  Created by DUONG on 25/05/2017.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
