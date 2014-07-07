//
//  ValidatorType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/2/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

import Foundation

class ValidationStatus {
    let valid = "ValidationStatusValid"
    let invalid = "ValidationStatusInvalid"
}

let ValidatorUpdateNotification:String = "ValidatorUpdateNotification"


class ValidatorType {
    
    
    let status = ValidationStatus()
    
    var valid:Bool = false
    var sendsUpdates:Bool = false
    var identifier:NSString = ""
    var validationStates:String[] = []
    
    init () {
        self.validationStates = [self.status.invalid]
    }
    
    
    func isTextValid(text:String) -> Bool {
        self.valid = true
        self.validationStates.removeAll()
        self.validationStates.append(self.status.valid)
        
        return self.valid
    }
    
    class func type() -> String {
        return "ValidationTypeBase"
    }
    
}