//
//  TipCalculatorCollectionViewCell.swift
//  Tip Calculator
//
//  Created by admin on 9/1/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

class TipCalculatedCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var totalCalculatedValueLabel: UILabel!
    @IBOutlet weak var tipCalculatedValueLabel: UILabel!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    
    var tipPercentage: NSNumber = 0.0;
    
    class func nibNameForCell() -> String {
        return "TipCalculatedCollectionViewCell";
    }
    
    class func reuseIdentiferForCell() -> String {
        return "tipCell";
    }
    
    func updateCell(billTotal: Double, numberOfPeople: Int) {
        let tipCalculated: Double = self.tipPercentage.doubleValue * 0.01 * billTotal / Double(numberOfPeople);
        let totalCalculated: Double = (self.tipPercentage.doubleValue * 0.01 + 1) * billTotal / Double(numberOfPeople);
        self.tipPercentageLabel.text = self.tipPercentage.stringValue + "%";
        self.tipCalculatedValueLabel.text = CurrencyFormatter.sharedInstance.stringFromNumberWithoutCode(tipCalculated)! + ",";
        self.totalCalculatedValueLabel.text = CurrencyFormatter.sharedInstance.stringFromNumberWithoutCode(totalCalculated);
    }
}