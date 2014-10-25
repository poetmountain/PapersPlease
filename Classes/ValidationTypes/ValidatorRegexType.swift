//
//  ValidatorRegexType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/4/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

import Foundation

class ValidatorRegexType:ValidatorType {
    
    var regexString = ""
    
    override func isTextValid(text: String) -> Bool {
        
        var error:NSError? = nil
        
        self.valid = false
        
        if let regex = NSRegularExpression(pattern: self.regexString, options: .CaseInsensitive, error: &error) {
        
            let num_matches:Int = regex.numberOfMatchesInString(text, options: .ReportProgress, range: NSMakeRange(0, text.utf16Count))
        
            self.valid = (num_matches == 1)
            
        }
        
        // update states
        self.validationStates.removeAll()
        (self.valid) ? (self.validationStates.append(self.status.valid))
                     : (self.validationStates.append(self.status.invalid))
        
        return self.valid
    }
    
    class override func type() -> String {
        return "ValidationTypeRegex"
    }
    
}