//
//  ViewController.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/6/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var textField:UITextField = nil
    @IBOutlet var matchTextField:UITextField = nil
    
    var validationUnit:ValidationUnit!
    var validationManager:ValidationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.matchTextField.backgroundColor = UIColor.greenColor()
        
        let length_type:ValidatorLengthType = ValidatorLengthType(minimumCharacters:2, maximumCharacters:20)
        let email_type:ValidatorEmailType = ValidatorEmailType()
        let unit_validator_types = [length_type, email_type]
        
        self.validationUnit = ValidationUnit(validatorTypes: unit_validator_types, identifier: "unit")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("validationUnitStatusChange:"), name: ValidationUnitUpdateNotification, object: self.validationUnit)
        
        self.validationUnit.validateText("nico@somewhere.com")
        
        
        
        let compare_type:ValidatorUITextCompareType = ValidatorUITextCompareType()
        compare_type.registerTextFieldToMatch(self.matchTextField)
        
        self.validationManager = ValidationManager()
        self.validationManager.registerTextField(self.textField, validationTypes: [compare_type], identifier: "textfield")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("validationManagerStatusChange:"), name: ValidationStatusNotification, object: self.validationManager)
        
    }
    
    
    @objc func validationUnitStatusChange(notification:NSNotification) {
        
        let unit:ValidationUnit = notification.object as ValidationUnit
        NSLog("\(unit.identifier) is \(unit.valid)")
        
    }
    
    @objc func validationManagerStatusChange(notification:NSNotification) {
        
        let mgr:ValidationManager = notification.object as ValidationManager
        NSLog("manager is \(mgr.valid)")
        
        if (mgr.valid) {
            self.matchTextField.backgroundColor = UIColor.greenColor()
        } else {
            self.matchTextField.backgroundColor = UIColor.redColor()
        }
        
    }

}

