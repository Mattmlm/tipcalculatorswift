//
//  CurrencyTextField.swift
//  Tip Calculator
//
//  Created by admin on 8/28/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import Foundation
import UIKit

class CurrencyTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        layer.borderColor = UIColor.greenColor().CGColor
        layer.borderWidth = 1.0
        
        println("Instantiated")
    }
}