//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by admin on 9/1/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var currencyPickerView: UIPickerView!;
    @IBOutlet weak var currencyDisplayLabel: UILabel!;
    @IBOutlet weak var currencyPickerToolbar: UIToolbar!;
    @IBOutlet weak var tipPercentageField: UITextField!;
    @IBOutlet weak var tipPercentageSymbolLabel: UILabel!;
    
    var currencyPickerData: Array<String> = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.setUpCurrencyPicker();
        
        self.tipPercentageField.delegate = self;
        
        // If user taps outside of keyboard, text fields should be deselected
        let deselectTextFieldTapGesture = UITapGestureRecognizer(target: self, action: "deselectTextField:");
        self.view.addGestureRecognizer(deselectTextFieldTapGesture);
        
        // If user taps percentage label, this should select the percentage field
        let selectPercentageTapGesture = UITapGestureRecognizer(target: self, action: "selectPercentageField:");
        self.tipPercentageSymbolLabel.addGestureRecognizer(selectPercentageTapGesture);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.barTintColor = UIColor(hexCode: kMainColorGreen);
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        self.updateDefaultLabels();
    }
    
    func setUpCurrencyPicker() {
        
        // Set delegate and datasource
        currencyPickerView.delegate = self;
        currencyPickerView.dataSource = self;
        
        // Setup UX interactions to select currency setting
        let selectCurrencyDisplayLabel: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "currencyLabelSelected:");
        self.currencyDisplayLabel.addGestureRecognizer(selectCurrencyDisplayLabel);
        
        // Setup Currency options data
        let unsortedCountryNamesArray:[String] = NSLocale.commonISOCurrencyCodes() ;
        let sortedCountryArray = unsortedCountryNamesArray.sort(<);
        self.currencyPickerData = sortedCountryArray;
    }
    
    func updateDefaultLabels() {
        let defaults = NSUserDefaults.standardUserDefaults();
        
        // Update currency
        var currencyCode = defaults.stringForKey(kCurrencyCodeDefault);
        let currencyIndex = defaults.integerForKey(kCurrencyIndexDefault);
        if (currencyCode == nil) {
            currencyCode = NSLocale.currentLocale().objectForKey(NSLocaleCurrencyCode) as? String;
        }
        currencyDisplayLabel.text = currencyCode;
        currencyPickerView.selectRow(currencyIndex, inComponent: 0, animated: false);
        
        // Update tip percentage
        let tipPercentage = defaults.objectForKey(kTipPercentageDefault);
        if (tipPercentage == nil) {
            tipPercentageField.text = "15";
        } else {
            tipPercentageField.text = String(tipPercentage as! Int);
        }
    }
    
    @IBAction func finishSelectingCurrency(sender:UIBarButtonItem) {
        self.currencyPickerView.hidden = true;
        self.currencyPickerToolbar.hidden = true;
        let selectedIndex = currencyPickerView.selectedRowInComponent(0);
        let currencyCode = currencyPickerData[selectedIndex];
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(currencyCode, forKey: kCurrencyCodeDefault);
        defaults.setInteger(selectedIndex, forKey: kCurrencyIndexDefault);
        defaults.synchronize();
        currencyDisplayLabel.text = currencyCode;
    }
    
    @IBAction func currencyLabelSelected(sender: UILabel) {
        self.currencyPickerView.hidden = false;
        self.currencyPickerToolbar.hidden = false;
    }
    
    //MARK: Gesture handlers
    func selectPercentageField(tap: UITapGestureRecognizer) {
        self.tipPercentageField.becomeFirstResponder();
    }
    
    func deselectTextField(tap: UITapGestureRecognizer) {
        self.tipPercentageField.resignFirstResponder();
    }
    
    //MARK: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currencyPickerData.count;
    }
    
    //MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyPickerData[row];
    }
    
    //MARK: UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults();
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string);
        
        // If Tip percentage field
        if (textField.isEqual(self.tipPercentageField)) {
            var newDefaultPercentage = newText.integerValue;
            newDefaultPercentage = min(newDefaultPercentage, 100);
            newDefaultPercentage = max(newDefaultPercentage, 0);
            
            defaults.setObject(newDefaultPercentage, forKey: kTipPercentageDefault);
            textField.text = String(newDefaultPercentage);
        }
        defaults.synchronize();
        return false;
    }
}