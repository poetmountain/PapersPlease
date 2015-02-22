//
//  ViewController.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/6/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var textField:UITextField! = nil
    @IBOutlet var matchTextField:UITextField! = nil
    
    var validationUnit:ValidationUnit!
    var validationManager:ValidationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.matchTextField.backgroundColor = UIColor.greenColor()
        
        let email_type:ValidatorEmailType = ValidatorEmailType()
        let unit_validator_types = [email_type]
        
        self.validationUnit = ValidationUnit(validatorTypes: unit_validator_types, identifier: "email")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("validationUnitStatusChange:"), name: ValidationUnitUpdateNotification, object: self.validationUnit)
        
        self.validationUnit.validateText("you@somewhere")
        
        
        let length_type:ValidatorLengthType = ValidatorLengthType(minimumCharacters:3, maximumCharacters:20)
        let compare_type:ValidatorUITextCompareType = ValidatorUITextCompareType()
        compare_type.registerTextFieldToMatch(self.matchTextField)
        
        self.validationManager = ValidationManager()
        self.validationManager.registerTextField(self.textField, validationTypes: [length_type, compare_type], identifier: "textfield")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("validationManagerStatusChange:"), name: ValidationStatusNotification, object: self.validationManager)
        
    }
    
    
    @objc func validationUnitStatusChange(notification:NSNotification) {
        
        let unit:ValidationUnit = notification.object as! ValidationUnit
        println("email validation: \(unit.identifier) is \(unit.valid) for \(unit.lastTextValue)")
        
    }
    
    @objc func validationManagerStatusChange(notification:NSNotification) {
        
        if let user_info = notification.userInfo {
            if let status_num:NSNumber = user_info["status"] as? NSNumber {
                let is_valid: Bool = status_num.boolValue ?? false
                
                println("manager is \(is_valid)")
                
                if (is_valid) {
                    self.matchTextField.backgroundColor = UIColor.greenColor()
                } else {
                    self.matchTextField.backgroundColor = UIColor.redColor()
                    
                    let all_errors:NSDictionary = user_info["errors"] as! NSDictionary
                    let textfield:NSDictionary = all_errors["textfield"] as! NSDictionary
                    let text_errors:NSDictionary = textfield["errors"] as! NSDictionary
                    println("textfield errors: \(text_errors)")
                    
                }
            }
        }
        
    }
    
}

