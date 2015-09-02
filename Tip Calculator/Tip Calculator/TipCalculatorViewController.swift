//
//  TipCalculatorViewController.swift
//  Tip Calculator
//
//  Created by admin on 8/26/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

class TipCalculatorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CurrencyTextFieldDelegate {

    @IBOutlet weak var billTotalField: CurrencyTextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tipCalculatedCollectionView: UICollectionView!
    @IBOutlet weak var numberOfPeopleView: UIView!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Latest/Default data management
    func loadLatestData() {
        
    }
    
    func clearLatestData() {
        
    }
    
    func loadDefaultData() {
        
    }
    
    //MARK: Helpers
    func updateTipCalculations(newBillValue: Double, numberOfPeople: NSNumber) {
        var cellsToUpdate = self.tipCalculatedCollectionView.visibleCells();
        let people = 1;
        for cell in cellsToUpdate {
            var tipCell:TipCalculatedCollectionViewCell = (cell as? TipCalculatedCollectionViewCell)!;
            tipCell.updateCell(newBillValue, numberOfPeople: people);
        }
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TipCalculatedCollectionViewCell.reuseIdentiferForCell(), forIndexPath: indexPath) as! TipCalculatedCollectionViewCell;
        cell.tipPercentage = indexPath.row;
        let billTotalNumber = CurrencyFormatter.sharedInstance.numberFromString(self.billTotalField.text);
        let billTotalDouble = billTotalNumber!.doubleValue;
        cell.updateCell(billTotalDouble, numberOfPeople: 1);

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

