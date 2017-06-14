//
//  UIImage+Decompression.swift
//  FlowerShopping
//
//  Created by DUONG on 25/05/2017.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import UIKit

extension UIImage {
    
    var decompressedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(at: CGPoint.zero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return decompressedImage!
    }
    
}

