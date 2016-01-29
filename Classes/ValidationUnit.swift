//
//  ValidationUnit.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/3/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

import Foundation
import UIKit

let ValidationUnitUpdateNotification:String = "ValidationUnitUpdateNotification"

class ValidationUnit {
    
    var registeredValidationTypes:[ValidatorType] = []
    var errors = [String:[String]]()
    var identifier = ""
    var valid:Bool = false
    var enabled:Bool = true
    let validationQueue:dispatch_queue_t
    
    var lastTextValue:String = ""
    
    init(validatorTypes:[ValidatorType]=[], identifier:String, initialText:String="") {
        
        self.validationQueue = dispatch_queue_create("com.poetmountain.ValidationUnitQueue", DISPATCH_QUEUE_SERIAL)
        self.registeredValidationTypes = validatorTypes
        self.identifier = identifier
        self.lastTextValue = initialText

        for type:ValidatorType in self.registeredValidationTypes {
            if (type.sendsUpdates) {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("validationUnitStatusUpdatedNotification:"), name: ValidatorUpdateNotification, object: type)
                type.isTextValid(self.lastTextValue)
            }
        }

    }


    func dealloc() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    
    // MARK: Validation methods
    
    func registerValidatorType (validatorType:ValidatorType) {
        self.registeredValidationTypes.append(validatorType)
    }
    
    func clearValidatorTypes () {
        self.registeredValidationTypes.removeAll()
    }
    
    
    func validationComplete () {
        // first remove any old errors
        self.errors.removeAll()
        
        var total_errors = [String:[String:[String]]]()
        
        if (!self.valid) {
            for validator_type:ValidatorType in self.registeredValidationTypes {
                if (!validator_type.valid) {
                    self.errors[validator_type.dynamicType.type()] = validator_type.validationStates
                }
            }
            total_errors = ["errors" : self.errors]
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(ValidationUnitUpdateNotification, object: self, userInfo: total_errors)
    }
    
    
    func validateText(text:String) {
        
        if (self.enabled) {
            dispatch_async(self.validationQueue, {
                [weak self] in
                
                if let strong_self = self {
                    
                    // add up the number of valid validation tests (coercing each Bool result to an Int)
                    let num_valid = strong_self.registeredValidationTypes.reduce(0) { (lastValue, type:ValidatorType) in
                        lastValue + Int(type.isTextValid(text))
                    }
                    
                    // use the number of total validations to set a global validation status
                    let type_count = strong_self.registeredValidationTypes.count
                    (num_valid == type_count) ? (strong_self.valid = true) : (strong_self.valid = false)
                    
                    // set the current text value to be the last value to prepare for the next validation request
                    strong_self.lastTextValue = text
                    
                    // send notification (on main queue, there be UI work)
                    dispatch_async(dispatch_get_main_queue(), {
                        strong_self.validationComplete()
                    })
                }
                
            })
        }
        
    }
    
    
    
    // MARK: Utility methods
    
    func validatorTypeForIdentifier(identifier:String) -> ValidatorType? {
        var validator_type: ValidatorType?
        
        for type:ValidatorType in self.registeredValidationTypes {
            if (type.identifier == identifier) {
                validator_type = type
                break
            }
        }

        return validator_type
    }
    
    
    
    // MARK: Notifications
    
    @objc func textDidChangeNotification(notification:NSNotification) {
        
        if (notification.name == UITextFieldTextDidChangeNotification) {
            guard let text_field:UITextField = notification.object as? UITextField else { return }
            guard let text = text_field.text else { return }
            self.validateText(text)
    
        } else if (notification.name == UITextViewTextDidChangeNotification) {
            guard let text_view:UITextView = notification.object as? UITextView else { return }
            guard let text = text_view.text else { return }
            self.validateText(text)
        }
    }
    
    
    @objc func validationUnitStatusUpdatedNotification(notification:NSNotification) {
        
        if (!self.enabled) { return }
        
        guard let user_info = notification.userInfo else { return }
        guard let status_num:NSNumber = user_info["status"] as? NSNumber else { return }
        let is_valid: Bool = status_num.boolValue ?? false
        
        if (is_valid) {
            self.validateText(self.lastTextValue)
            
        } else {
            self.valid = false
            self.validationComplete()
        }

    }
    
}