//
//  CurrencyFormatter.swift
//  Tip Calculator
//
//  Created by admin on 9/1/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

public class CurrencyFormatter: NSNumberFormatter {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        self.locale = NSLocale.currentLocale()
        self.maximumFractionDigits = 2
        self.minimumFractionDigits = 2
        self.alwaysShowsDecimalSeparator = true
        self.numberStyle = .CurrencyStyle
    }
    
    // Swift 1.2 or above
    //  static let sharedInstance = CurrencyFormatter()
    class var sharedInstance: CurrencyFormatter {
        struct Static {
            static let instance = CurrencyFormatter()
        }
        return Static.instance
    }
}