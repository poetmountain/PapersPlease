//
//  ValidatorUITextCompareType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/4/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

import Foundation
import UIKit

class ValidatorUITextCompareType:ValidatorStringCompareType {
    
    var lastStringValue:String = ""

    init()  {
        super.init()
        self.sendsUpdates = true
    }

    func dealloc() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func isTextValid(text: String) -> Bool {
        
        super.isTextValid(text)
        self.lastStringValue = text
        
        return self.valid
    }
    
    
    func registerTextFieldToMatch(textField:UITextField) {
        
        // add listener for object which will pass on text changes to validator unit
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textDidChangeNotification:"), name: UITextFieldTextDidChangeNotification, object: textField)
        
        self.comparisonString = textField.text
        
    }
    
    func registerTextViewToMatch(textView:UITextView) {
        
        // add listener for object which will pass on text changes to validator unit
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textDidChangeNotification:"), name: UITextViewTextDidChangeNotification, object: textView)
        
        self.comparisonString = textView.text
        
    }
    
    
    // Notification methods
    
    @objc func textDidChangeNotification(notification:NSNotification) {

        if (notification.name == UITextFieldTextDidChangeNotification) {
            let text_field:UITextField = notification.object as UITextField
            self.comparisonString = text_field.text
        } else if (notification.name == UITextViewTextDidChangeNotification) {
            let text_view:UITextView = notification.object as UITextView
            self.comparisonString = text_view.text
        }
        
        // because we are observing a UI text object to match against, we have to manually re-validate here
        // otherwise, .valid could return true when it actually isn't
        self.valid = self.isTextValid(self.lastStringValue)
        
        // post notification
        let dict = ["status" : self.valid] as NSDictionary
        NSNotificationCenter.defaultCenter().postNotificationName(ValidatorUpdateNotification, object: self, userInfo: dict)
        
    }
    
    
    
    class override func type() -> String {
        return "ValidationTypeUITextCompare"
    }
    

}