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
    func currencyTextField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, fieldValue: Double) -> Bool
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
        let isBackspace = string.isEmpty;
        let originalString = textField.text;
        let newString = string;
        var newTextFieldString: NSString;
        
        //  Get non-numeric set
        let setToKeep: NSCharacterSet = NSCharacterSet(charactersInString: "0123456789");
        let setToRemove: NSCharacterSet = setToKeep.invertedSet;
        let numericOriginalString = originalString!.componentsSeparatedByCharactersInSet(setToRemove).joinWithSeparator("");
        let numericNewString = newString.componentsSeparatedByCharactersInSet(setToRemove).joinWithSeparator("");
        
        var numericString: NSString = numericOriginalString.stringByAppendingString(numericNewString);
        if (isBackspace) {
            numericString = numericString.substringToIndex(numericString.length - 1);
        }
        
        let stringValue: Double = numericString.doubleValue / 100;
        let stringValueDecimalNumber: NSNumber = NSDecimalNumber(double: stringValue);
        newTextFieldString = formatter.stringFromNumber(stringValueDecimalNumber)!;
        
        textField.text = newTextFieldString as String;
        delegate?.currencyTextField(textField, shouldChangeCharactersInRange: range, replacementString: string, fieldValue: stringValue);
        return false;
    }
}