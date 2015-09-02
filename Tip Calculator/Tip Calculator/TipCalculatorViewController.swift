//
//  TipCalculatorViewController.swift
//  Tip Calculator
//
//  Created by admin on 8/26/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

class TipCalculatorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CurrencyTextFieldDelegate {

    @IBOutlet weak var billTotalField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tipCalculatedCollectionView: UICollectionView!
    @IBOutlet weak var numberOfPeopleView: UIView!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    
    var tipPercentageToScrollToIndexPath: NSIndexPath = NSIndexPath(forRow: 15, inSection: 0);
    var currencyTextFieldDelegate: CurrencyTextFieldController = CurrencyTextFieldController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        billTotalField.delegate = currencyTextFieldDelegate;
        currencyTextFieldDelegate.formatter = CurrencyFormatter.sharedInstance;
        
        currencyTextFieldDelegate.delegate = self;
        self.billTotalField.becomeFirstResponder();

        var tipCellNib = UINib(nibName: TipCalculatedCollectionViewCell.nibNameForCell(), bundle: nil);
        self.tipCalculatedCollectionView.registerNib(tipCellNib, forCellWithReuseIdentifier: TipCalculatedCollectionViewCell.reuseIdentiferForCell());
        self.tipCalculatedCollectionView.delegate = self;
        self.tipCalculatedCollectionView.dataSource = self;
        
        self.loadLatestData();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.loadDefaultData();
        self.clearLatestData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.tipCalculatedCollectionView.scrollToItemAtIndexPath(self.tipPercentageToScrollToIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Latest/Default data management
    func loadLatestData() {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        let lastDate = defaults.objectForKey(kLastCloseDate) as? NSDate;
        if (lastDate == nil) {
            return;
        }
        let timeDiff:NSTimeInterval = NSDate().timeIntervalSinceDate(lastDate!);
        
        let lastTipPercentage = defaults.integerForKey(kLastTipPercentage);
        let lastBillTotal = defaults.stringForKey(kLastBillTotal);
        
        // If less than 10 minutes have passed and something has been recorded, set bill total, number of people to split by, and tip percentage to what was last present
        if timeDiff < 600 {
            self.tipPercentageToScrollToIndexPath = NSIndexPath(forRow: lastTipPercentage, inSection: 0);
            self.billTotalField.text = lastBillTotal;
        }
    }
    
    func clearLatestData() {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        defaults.removeObjectForKey(kLastBillTotal);
        defaults.removeObjectForKey(kLastTipPercentage);
        defaults.removeObjectForKey(kLastBillSplitNumber);
        defaults.synchronize();
    }
    
    func loadDefaultData() {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        let lastTipPercentage = defaults.objectForKey(kLastTipPercentage);
        
        // Update currency marker
        var numericValue = self.getBillValue(self.billTotalField.text);
        let defaultCurrencyCode = defaults.stringForKey(kCurrencyCodeDefault);
        if (defaultCurrencyCode != nil) {
            CurrencyFormatter.sharedInstance.locale = NSLocale.getLocaleWithCurrencyCode(defaultCurrencyCode!);
        }
        let newString = CurrencyFormatter.sharedInstance.stringFromNumber(numericValue);
        self.billTotalField.text = newString;
        self.updateTipCalculations(numericValue, numberOfPeople: 1);
        
        // Update default percentage
        if (lastTipPercentage == nil) {
            let tipPercentage = defaults.objectForKey(kTipPercentageDefault);
            if (tipPercentage != nil) {
                let row = tipPercentage as! Int;
                self.tipPercentageToScrollToIndexPath = NSIndexPath(forRow: row, inSection: 0);
            }
        }
    }
    
    func recordLastSettings() {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(self.billTotalField.text, forKey: kLastBillTotal);
        let tipIndexPath = self.centerTipPercentageIndexPath();
        if (tipIndexPath != nil) {
            defaults.setInteger(tipIndexPath!.row, forKey: kLastTipPercentage);
        } else {
            defaults.setInteger(self.tipPercentageToScrollToIndexPath.row, forKey: kLastTipPercentage);
        }
        defaults.setObject(self.numberOfPeopleLabel.text, forKey: kLastBillSplitNumber);
        defaults.synchronize();
    }
    
    //MARK: Helpers
    func getBillValue(billValue: String) -> Double {
        let setToKeep: NSCharacterSet = NSCharacterSet(charactersInString: "0123456789");
        let setToRemove: NSCharacterSet = setToKeep.invertedSet;
        let numericOriginalString: NSString = join("", billValue.componentsSeparatedByCharactersInSet(setToRemove));
        return numericOriginalString.doubleValue / 100;
    }
    
    func updateTipCalculations(newBillValue: Double, numberOfPeople: NSNumber) {
        var cellsToUpdate = self.tipCalculatedCollectionView.visibleCells();
        let people = 1;
        for cell in cellsToUpdate {
            var tipCell:TipCalculatedCollectionViewCell = (cell as? TipCalculatedCollectionViewCell)!;
            tipCell.updateCell(newBillValue, numberOfPeople: people);
        }
    }
    
    func centerTipPercentageIndexPath() -> NSIndexPath? {
        let visibleCells = self.tipCalculatedCollectionView.visibleCells() as! [UICollectionViewCell];
        let centerX: CGFloat = self.tipCalculatedCollectionView.contentOffset.x + UIScreen.mainScreen().bounds.size.width/2;
        let centerRect: CGRect = CGRectMake(centerX, self.tipCalculatedCollectionView.frame.size.height / 2, 1, 1);
        for cell:UICollectionViewCell in visibleCells {
            let isCellCenter:Bool = CGRectIntersectsRect(centerRect, cell.frame);
            if (isCellCenter) {
                return self.tipCalculatedCollectionView.indexPathForCell(cell)!;
            }
        }
        return nil;
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 101;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TipCalculatedCollectionViewCell.reuseIdentiferForCell(), forIndexPath: indexPath) as! TipCalculatedCollectionViewCell;
        cell.tipPercentage = indexPath.row;
        let billTotalNumber = getBillValue(self.billTotalField.text);
        cell.updateCell(billTotalNumber, numberOfPeople: 1);

        return cell;
    }
    
    //MARK: UICollectionViewDelegateFlowLayout protocol methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width / 2.0, self.tipCalculatedCollectionView.frame.size.height);
    }
    
    //MARK: CurrencyTextFieldDelegate
    func currencyTextField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, fieldValue: Double) -> Bool {
        self.updateTipCalculations(fieldValue, numberOfPeople: 1);
        return true;
    }
}

