//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by admin on 9/1/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var countriesArray = getAllCountryLocales();
        for countryCode in countriesArray {
            println("locale is \(countryCode)");
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.barTintColor = UIColor(hexCode: kMainColorGreen);
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
    }
    
    func getAllCountryLocales() -> Array<String> {
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
}