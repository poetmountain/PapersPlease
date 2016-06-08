//
//  ValidatorLengthType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/3/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

import Foundation

public let IgnoreLengthConstraint:Int = -1

public enum LengthValidationStatus : String {
    case MinimumLengthError = "ValidationStatusMinimumLengthError"
    case MaximumLengthError = "ValidationStatusMaximumLengthError"
}


public class ValidatorLengthType:ValidatorType {
    
    public var minimumCharacters:Int = IgnoreLengthConstraint
    public var maximumCharacters:Int = IgnoreLengthConstraint
    
    public init(minimumCharacters:Int, maximumCharacters:Int)  {
        super.init()
        self.minimumCharacters = minimumCharacters
        self.maximumCharacters = maximumCharacters
    }
    
    
    public override func isTextValid(text: String) -> Bool {
        
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
            self.validationStates.append(ValidationStatus.Valid.rawValue)
            
        } else {
            
            if (!min_valid) {
                self.validationStates.append(LengthValidationStatus.MinimumLengthError.rawValue)
            }
            if (!max_valid) {
                self.validationStates.append(LengthValidationStatus.MaximumLengthError.rawValue)
            }
        }
        
        
        return self.valid
    }

    public class override func type() -> String {
        return "ValidationTypeLength"
    }
    
}