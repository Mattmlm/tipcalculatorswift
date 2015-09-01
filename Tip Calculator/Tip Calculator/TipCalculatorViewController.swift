//
//  TipCalculatorViewController.swift
//  Tip Calculator
//
//  Created by admin on 8/26/15.
//  Copyright (c) 2015 mattmo. All rights reserved.
//

import UIKit

class TipCalculatorViewController: UIViewController, CurrencyTextFieldDelegate {

    @IBOutlet weak var billTotalField: CurrencyTextField!
    var currencyTextFieldDelegate: CurrencyTextFieldController = CurrencyTextFieldController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        billTotalField.delegate = currencyTextFieldDelegate;
        currencyTextFieldDelegate.delegate = self;
        self.billTotalField.becomeFirstResponder();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func currencyTextField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, fieldValue: Float) -> Bool {   
        return true;
    }
}

