//
//  ValidatorRegexType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/4/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

import Foundation

public class ValidatorRegexType:ValidatorType {
    
    public var regexString = ""
    
    public override func isTextValid(text: String) -> Bool {
        
        self.valid = false
        
        if let regex = try? NSRegularExpression(pattern: self.regexString, options: .CaseInsensitive) {
        
            let num_matches:Int = regex.numberOfMatchesInString(text, options:[], range: NSMakeRange(0, text.utf16.count))
        
            self.valid = (num_matches == 1)
            
        }
        
        // update states
        self.validationStates.removeAll()
        (self.valid) ? (self.validationStates.append(ValidationStatus.Valid.rawValue))
                     : (self.validationStates.append(ValidationStatus.Invalid.rawValue))
        
        return self.valid
    }

    public class override func type() -> String {
        return "ValidationTypeRegex"
    }
    
}