//
//  ValidatorStringCompareType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/2/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

import Foundation

public class ValidatorStringCompareType:ValidatorType {
    
    public enum ComparisonType {
        case Equals, NotEquals
    }
    
    public var comparisonString:String = ""
    public var comparisonType:ComparisonType = .Equals
    
    
    public override func isTextValid(text: String) -> Bool {
        
        if (self.comparisonType == .Equals) {
            self.valid = (text == self.comparisonString)
        } else if (self.comparisonType == .NotEquals) {
            self.valid = !(text == self.comparisonString)
        }
        
        return self.valid
    }

    public class override func type() -> String {
        return "ValidationTypeStringCompare"
    }
}