//
//  ValidatorUITextCompareType.swift
//  PapersPlease
//
//  Created by Brett Walker on 7/4/14.
//  Copyright (c) 2014-2016 Poet & Mountain, LLC. All rights reserved.
//

import Foundation
import UIKit

class ValidatorUITextCompareType:ValidatorStringCompareType {
    
    var lastStringValue:String = ""

    override init()  {
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
        
        guard let text = textField.text else { return }
        self.comparisonString = text
        
    }
    
    func registerTextViewToMatch(textView:UITextView) {
        
        // add listener for object which will pass on text changes to validator unit
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textDidChangeNotification:"), name: UITextViewTextDidChangeNotification, object: textView)
        
        guard let text = textView.text else { return }
        self.comparisonString = text
        
    }
    
    
    // MARK: Notification methods
    
    @objc func textDidChangeNotification(notification:NSNotification) {

        if (notification.name == UITextFieldTextDidChangeNotification) {
            guard let text_field:UITextField = notification.object as? UITextField else { return }
            guard let text = text_field.text else { return }
            self.comparisonString = text
            
        } else if (notification.name == UITextViewTextDidChangeNotification) {
            guard let text_view:UITextView = notification.object as? UITextView else { return }
            guard let text = text_view.text else { return }
            self.comparisonString = text
        }
        
        // because we are observing a UI text object to match against, we have to manually re-validate here
        // otherwise, .valid could return true when it actually isn't
        self.valid = self.isTextValid(self.lastStringValue)
        
        // post notification
        let dict = ["status" : self.valid]
        NSNotificationCenter.defaultCenter().postNotificationName(ValidatorUpdateNotification, object: self, userInfo: dict)
        
    }
    
    
    
    class override func type() -> String {
        return "ValidationTypeUITextCompare"
    }
    

}