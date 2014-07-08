//
//  ValidationManager.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/5/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

import Foundation
import UIKit

let ValidationStatusNotification:String = "ValidationStatusNotification"


class ValidationManager {
    
    var validationUnits = [String:ValidationUnit]()
    var valid:Bool = false
    
    
    func registerTextField(textField:UITextField, validationTypes:[ValidatorType]=[], identifier:String?) -> ValidationUnit {
        let unit:ValidationUnit = self.registerObject(textField, validationTypes: validationTypes, objectNotificationType: UITextFieldTextDidChangeNotification, initialText: textField.text, identifier: identifier?)
        
        return unit
    }
    
    func registerTextView(textView:UITextView, validationTypes:[ValidatorType]=[], identifier:String?) -> ValidationUnit {
        let unit:ValidationUnit = self.registerObject(textView, validationTypes: validationTypes, objectNotificationType: UITextViewTextDidChangeNotification, initialText: textView.text, identifier: identifier?)
        
        return unit
    }
    
    
    
    func registerObject(object:AnyObject, validationTypes:[ValidatorType]=[], objectNotificationType:String, initialText:String, identifier:String?) -> ValidationUnit {
        
        var unit_identifier:String! = identifier?
        if (!unit_identifier) {
            // if no id passed in, create one
            unit_identifier = "\(self.validationUnits.count+1)"
        }
        
        // create validation unit with passed-in types and store a reference
        let unit:ValidationUnit = ValidationUnit(validatorTypes: validationTypes, identifier: unit_identifier!, initialText: initialText)
        self.validationUnits[unit_identifier] = unit
        
        // add listener for object which will pass on text changes to validation unit
        NSNotificationCenter.defaultCenter().addObserver(unit, selector: Selector("textDidChangeNotification:"), name: objectNotificationType, object: object)
        
        
        // listen for validation updates from unit
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("unitUpdateNotificationHandler:"), name: ValidationUnitUpdateNotification, object: unit)

        
        return unit
    }
    
    
    func dealloc() {
        NSNotificationCenter.defaultCenter().removeObserver(self)        
    }
    
    
    
    // Utility methods
    
    func unitForIdentifier(identifier:String) -> ValidationUnit? {
        let unit:ValidationUnit? = self.validationUnits[identifier]
        
        return unit
    }
    
    
    func checkValidationForText() {
        
        for (key, unit) in self.validationUnits {
            unit.validateText(unit.lastTextValue)
        }
    }
    
    
    func validationStatusForAllUnits() -> Bool {
        
        var is_valid:Bool = true
        
        for (key, unit) in self.validationUnits {
            if (!unit.valid) {
                is_valid = false
                break
            }
        }
        
        return is_valid
    }
    
    
    
    // Notification methods
    
    @objc func unitUpdateNotificationHandler(notification:NSNotification) {
        
        // update overall validation status
        self.valid = self.validationStatusForAllUnits()
        
        // *** using NSDictionarys here because Xcode crashes on converted Swift's native Bool support in dicts

        // collect all unit errors
        var total_errors = NSMutableDictionary.dictionary()
        for (key, unit) in self.validationUnits {
            let errors = ["valid" : unit.valid, "errors" : unit.errors] as NSDictionary
            total_errors[unit.identifier] = errors
        }
        
        // post status update notification
        let status_dict = ["status" : self.valid, "errors" : total_errors] as NSDictionary
        NSNotificationCenter.defaultCenter().postNotificationName(ValidationStatusNotification, object: self, userInfo: status_dict)
        
    }
    
}