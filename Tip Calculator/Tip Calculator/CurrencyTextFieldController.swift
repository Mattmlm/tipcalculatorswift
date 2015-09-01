//
//  CurrencyTextFieldController.swift
//  Tip Calculator
//
//  Created by admin on 8/28/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencyTextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
}

class CurrencyTextFieldController: NSObject, UITextFieldDelegate {
    
    var delegate: CurrencyTextFieldDelegate?
    
    override init() {
        super.init();
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        delegate?.textField(textField, shouldChangeCharactersInRange: range, replacementString: string);
        return true;
    }
}