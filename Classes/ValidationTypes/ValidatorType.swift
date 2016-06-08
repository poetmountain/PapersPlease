//
//  ValidatorType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/2/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

import Foundation

public enum ValidationStatus: String {
    case Valid = "ValidationStatusValid"
    case Invalid = "ValidationStatusInvalid"
}


public let ValidatorUpdateNotification:String = "ValidatorUpdateNotification"


public class ValidatorType {
    
    internal(set) public var valid:Bool = false
    internal(set) public var sendsUpdates:Bool = false
    public var identifier:NSString = ""
    internal(set) public var validationStates:[String] = []

    
    public init () {
        self.validationStates = [ValidationStatus.Invalid.rawValue]
    }
    
    
    public func isTextValid(text:String) -> Bool {
        self.valid = true
        self.validationStates.removeAll()
        self.validationStates.append(ValidationStatus.Valid.rawValue)
        
        return self.valid
    }

    class func type() -> String {
        return "ValidationTypeBase"
    }
    
}