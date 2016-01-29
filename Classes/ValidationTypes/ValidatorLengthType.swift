//
//  ValidatorLengthType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/3/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

import Foundation

let IgnoreLengthConstraint:Int = -1

class LengthValidationStatus : ValidationStatus {
    let minimumLengthError = "ValidationStatusMinimumLengthError"
    let maximumLengthError = "ValidationStatusMaximumLengthError"
}


class ValidatorLengthType:ValidatorType {
    
    var minimumCharacters:Int = IgnoreLengthConstraint
    var maximumCharacters:Int = IgnoreLengthConstraint
    
    init(minimumCharacters:Int, maximumCharacters:Int)  {
        super.init()
        self.minimumCharacters = minimumCharacters
        self.maximumCharacters = maximumCharacters
    }

    var compareStatus = LengthValidationStatus()
    
    override var status: ValidationStatus {
        get {
            return compareStatus
        }
        set(status) {
            self.status = status
        }
    }
    
    override func isTextValid(text: String) -> Bool {
        
        var min_valid = true
        var max_valid = true
        
        // determine min validity
        if (self.minimumCharacters == IgnoreLengthConstraint) {
            min_valid = true
            
        } else if (self.minimumCharacters >= 0) {
            (text.utf16.count >= self.minimumCharacters) ? (min_valid = true) : (min_valid = false)
        }
        
        // determine max validity
        if (self.maximumCharacters == IgnoreLengthConstraint) {
            max_valid = true
            
        } else if (self.maximumCharacters >= 0 && self.maximumCharacters >= self.minimumCharacters) { // if max is less than min, the max constraint is ignored
            (text.utf16.count <= self.maximumCharacters) ? (max_valid = true) : (max_valid = false)
        }
        
        (min_valid && max_valid) ? (valid = true) : (valid = false)
        
        
        // update states
        self.validationStates.removeAll()
        if (self.valid) {
            self.validationStates.append(self.status.valid)
            
        } else {
            let length_status = self.status as! LengthValidationStatus
            
            if (!min_valid) {
                self.validationStates.append(length_status.minimumLengthError)
            }
            if (!max_valid) {
                self.validationStates.append(length_status.maximumLengthError)
            }
        }
        
        
        return self.valid
    }
    
    
    class override func type() -> String {
        return "ValidationTypeLength"
    }
    
}