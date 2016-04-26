//
//  ValidationManager.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/5/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

import Foundation
import UIKit

let ValidationStatusNotification:String = "ValidationStatusNotification"


class ValidationManager {
    
    var validationUnits = [String:ValidationUnit]()
    var valid:Bool = false
    var identifierCounter = 0
    
    
    func registerTextField(textField:UITextField, validationTypes:[ValidatorType]=[], identifier:String?) -> ValidationUnit {
        let initial_text = textField.text ?? ""
        let unit:ValidationUnit = self.registerObject(textField, validationTypes: validationTypes, objectNotificationType: UITextFieldTextDidChangeNotification, initialText: initial_text, identifier: identifier)
        
        return unit
    }
    
    func registerTextView(textView:UITextView, validationTypes:[ValidatorType]=[], identifier:String?) -> ValidationUnit {
        let initial_text = textView.text ?? ""
        let unit:ValidationUnit = self.registerObject(textView, validationTypes: validationTypes, objectNotificationType: UITextViewTextDidChangeNotification, initialText: initial_text, identifier: identifier)
        
        return unit
    }
    
    
    
    func registerObject(object:AnyObject, validationTypes:[ValidatorType]=[], objectNotificationType:String, initialText:String, identifier:String?) -> ValidationUnit {
        
        // if no identifier passed in, generate one
        let unit_identifier:String = identifier ?? self.generateIdentifier()
        
        // create validation unit with passed-in types and store a reference
        let unit:ValidationUnit = ValidationUnit(validatorTypes: validationTypes, identifier: unit_identifier, initialText: initialText)
        self.validationUnits[unit_identifier] = unit
        
        // add listener for object which will pass on text changes to validation unit
        NSNotificationCenter.defaultCenter().addObserver(unit, selector: #selector(ValidationUnit.textDidChangeNotification(_:)), name: objectNotificationType, object: object)
        
        
        // listen for validation updates from unit
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ValidationManager.unitUpdateNotificationHandler(_:)), name: ValidationUnitUpdateNotification, object: unit)

        
        return unit
    }
    
    
    func addUnit(unit:ValidationUnit, identifier:String?) -> String {
        
        // if an identifier is passed in, that is used instead of the unit's identifier property
        // if no identifier passed in and no identifier found on the unit, generate one
        let unit_identifier:String = (identifier ?? unit.identifier) ?? self.generateIdentifier()

        self.validationUnits[unit_identifier] = unit

        // listen for validation updates from unit
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ValidationManager.unitUpdateNotificationHandler(_:)), name: ValidationUnitUpdateNotification, object: unit)
        
        return unit_identifier
    }
    
    
    func removeUnitForIdentifier(identifier:String) {
        
        // remove validation update listener for this unit
        let unit = self.unitForIdentifier(identifier)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ValidationUnitUpdateNotification, object: unit)
        
        self.validationUnits.removeValueForKey(identifier)
    }
    
    
    func dealloc() {
        NSNotificationCenter.defaultCenter().removeObserver(self)        
    }
    
    
    
    // MARK: Utility methods
    
    func unitForIdentifier(identifier:String) -> ValidationUnit? {
        let unit:ValidationUnit? = self.validationUnits[identifier]
        
        return unit
    }
    
    
    func generateIdentifier() -> String {
        identifierCounter += 1
        let identifier = "\(identifierCounter)"
        
        return identifier
    }
    
    
    func checkValidationForText() {
    
        for (_, unit) in self.validationUnits {
            unit.validateText(unit.lastTextValue)
        }
    }
    
    
    func validationStatusForAllUnits() -> Bool {
        
        var is_valid:Bool = true
        
        for (_, unit) in self.validationUnits {
            if (unit.enabled && !unit.valid) {
                is_valid = false
                break
            }
        }
        
        return is_valid
    }
    
    
    
    // MARK: Notification methods
    
    @objc func unitUpdateNotificationHandler(notification:NSNotification) {
        
        // update overall validation status
        self.valid = self.validationStatusForAllUnits()
        
        // *** using NSDictionarys here because Xcode crashes on converted Swift's native Bool support in dicts

        // collect all unit errors
        let total_errors = NSMutableDictionary()
        for (_, unit) in self.validationUnits {
            let errors = ["valid" : unit.valid, "errors" : unit.errors]
            total_errors[unit.identifier] = errors
        }
        
        // post status update notification
        let status_dict = ["status" : self.valid, "errors" : total_errors.copy()]
        NSNotificationCenter.defaultCenter().postNotificationName(ValidationStatusNotification, object: self, userInfo: status_dict)
        
    }
    
}