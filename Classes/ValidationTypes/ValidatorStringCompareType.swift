//
//  ValidatorStringCompareType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/2/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

import Foundation

class ValidatorStringCompareType:ValidatorType {
    
    enum ComparisonType {
        case Equals, NotEquals
    }
    
    var comparisonString:String = ""
    var comparisonType:ComparisonType = .Equals
    
    
    override func isTextValid(text: String) -> Bool {
        
        if (self.comparisonType == .Equals) {
            self.valid = (text == self.comparisonString)
        } else if (self.comparisonType == .NotEquals) {
            self.valid = !(text == self.comparisonString)
        }
        
        return self.valid
    }
    
    class override func type() -> String {
        return "ValidationTypeStringCompare"
    }

}