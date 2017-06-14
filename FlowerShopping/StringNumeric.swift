//
//  StringNumeric.swift
//  FlowerShopping
//
//  Created by DUONG PHAM on 5/15/17.
//  Copyright © 2017 DUONGPHAM. All rights reserved.
//

import Foundation

extension String {
    func isNumericString() -> Bool {
        
        let nonDigitChars = CharacterSet.decimalDigits.inverted
        
        let string = self as NSString
        
        if string.rangeOfCharacter(from: nonDigitChars).location == NSNotFound {
            // definitely numeric entierly
            return true
        }
        
        return false
    }
}
