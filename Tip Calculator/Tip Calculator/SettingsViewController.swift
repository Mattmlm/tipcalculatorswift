//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by admin on 9/1/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var currencyPickerView: UIPickerView!;
    @IBOutlet weak var currencyDisplayLabel: UILabel!;
    @IBOutlet weak var currencyPickerToolbar: UIToolbar!;
    var currencyPickerData: Array<String> = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.setUpCurrencyPicker();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.barTintColor = UIColor(hexCode: kMainColorGreen);
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
    }
    
    func setUpCurrencyPicker() {
        
        // Set delegate and datasource
        currencyPickerView.delegate = self;
        currencyPickerView.dataSource = self;
        
        // Setup UX interactions to select currency setting
        var selectCurrencyDisplayLabel: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "currencyLabelSelected:");
        self.currencyDisplayLabel.addGestureRecognizer(selectCurrencyDisplayLabel);
        
        // Setup Currency options data
        let unsortedCountryNamesArray:[String] = NSLocale.commonISOCurrencyCodes() as! [String];
        let sortedCountryArray = sorted(unsortedCountryNamesArray, <);
        self.currencyPickerData = sortedCountryArray;
    }
    
    @IBAction func finishSelectingCurrency(sender:UIBarButtonItem) {
        self.currencyPickerView.hidden = true;
        self.currencyPickerToolbar.hidden = true;
        currencyDisplayLabel.text = currencyPickerData[currencyPickerView.selectedRowInComponent(0)];
    }
    
    @IBAction func currencyLabelSelected(sender: UILabel) {
        self.currencyPickerView.hidden = false;
        self.currencyPickerToolbar.hidden = false;
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
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return currencyPickerData[row];
    }
}