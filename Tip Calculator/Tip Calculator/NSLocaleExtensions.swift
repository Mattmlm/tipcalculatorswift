//
//  NSLocaleExtensions.swift
//  Tip Calculator
//
//  Created by admin on 9/1/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

extension NSLocale {
    class func getAllCountryLocalesArray() -> Array<String> {
        let locale = NSLocale.currentLocale()
        let countryArray = NSLocale.ISOCountryCodes()
        var unsortedCountryArray:[String] = []
        for countryCode in countryArray {
            let displayNameString = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
            if displayNameString != nil {
                unsortedCountryArray.append(displayNameString!)
            }
        }
        let sortedCountryArray = sorted(unsortedCountryArray, <)
        return sortedCountryArray;
    }
    class func getAllCountryCodeNamesDictionary() -> NSDictionary {
        let locale = NSLocale.currentLocale();
        let countryCodes = NSLocale.ISOCountryCodes();
        var countries:[String] = [];
        
        for countryCode in countryCodes {
            let displayNameString = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode);
            if displayNameString != nil {
                countries.append(displayNameString!);
            }
        }
        var codeForCountryDictionary = NSDictionary(objects: countryCodes, forKeys: countries);
        return codeForCountryDictionary;
    }
}