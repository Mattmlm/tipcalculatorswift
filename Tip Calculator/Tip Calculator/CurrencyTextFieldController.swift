//
//  CurrencyTextFieldController.swift
//  Tip Calculator
//
//  Created by admin on 8/28/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//
//  This class assumes that the users keyboard is specifically set to numberpad, there is no error checking


import UIKit

protocol CurrencyTextFieldDelegate {
    func currencyTextField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, fieldValue: Float) -> Bool
}

class CurrencyTextFieldController: NSObject, UITextFieldDelegate {
    
    var delegate: CurrencyTextFieldDelegate?
    var formatter: NSNumberFormatter = NSNumberFormatter();
    
    override init() {
        super.init();
        formatter.numberStyle = .CurrencyStyle;
    }
    
    func setFormatterLocale(newLocale: NSLocale) {
        formatter.locale = newLocale;
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var isBackspace = string.isEmpty;
        var originalString = textField.text;
        var newString = string;
        var newTextFieldString: NSString;
        
        //  Get non-numeric set
        var setToKeep: NSCharacterSet = NSCharacterSet(charactersInString: "0123456789");
        var setToRemove: NSCharacterSet = setToKeep.invertedSet;
        var numericOriginalString = join("", originalString.componentsSeparatedByCharactersInSet(setToRemove));
        var numericNewString = join("", newString.componentsSeparatedByCharactersInSet(setToRemove));
        
        var numericString: NSString = numericOriginalString.stringByAppendingString(numericNewString);
        if (isBackspace) {
            numericString = numericString.substringToIndex(numericString.length - 1);
        }
        
        let stringValue: Float = numericString.floatValue / 100;
        var stringValueDecimalNumber: NSNumber = NSDecimalNumber(float: stringValue);
        newTextFieldString = formatter.stringFromNumber(stringValueDecimalNumber)!;
        
        textField.text = newTextFieldString as String;
        delegate?.currencyTextField(textField, shouldChangeCharactersInRange: range, replacementString: string, fieldValue: stringValue);
        return false;
    }
}