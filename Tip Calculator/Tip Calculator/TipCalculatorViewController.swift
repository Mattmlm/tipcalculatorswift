//
//  TipCalculatorViewController.swift
//  Tip Calculator
//
//  Created by admin on 8/26/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

class TipCalculatorViewController: UIViewController, CurrencyTextFieldDelegate {

    @IBOutlet weak var billTotalField: UITextField!
    var currencyTextFieldDelegate: CurrencyTextFieldController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currencyTextFieldDelegate = CurrencyTextFieldController();
        
        billTotalField.delegate = currencyTextFieldDelegate;
        currencyTextFieldDelegate.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        println("testing delegate");
        return true;
    }
}

