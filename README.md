PapersPlease is a flexible, extendable text validation library for iOS, written in Apple's Swift language. The Objective-C version of this library is [PMValidation](https://github.com/poetmountain/PMValidation/). PapersPlease comes with several common validation types for often-used tasks like validating registration forms, however it was architected to be easily extended with your own validation types.

## Features

* Validate individual string objects or listen to changes from UIKit objects
* Modular – validation types can be used together to create complex validation constraints
* Extensible - Easily create your own validation types by subclassing ValidatorType
* Comes with several useful validation types to satisfy most validation needs
* Easily implement form validation by using ValidationManager to register UITextField and UITextView objects

## Overview

At its simplest, PapersPlease starts with an instance of a ValidatorType subclass. These classes provide the validation logic, and can be used directly if you just need a single validation test on your string. ValidatorType can be subclassed to provide your own custom validation logic. If you have a more complex validation test requiring several ValidatorType subclasses and need to determine an overall validation state for a string, use the ValidationUnit class. When you need to validate more than one string and determine a global validation state (e.g. a validation form), the ValidationManager class is useful. This class controls one or more ValidationUnit objects, providing an overall validation status and notification routing. This class also simplifies the validation of UIKit text input classes.

While this library does function as stated, the Swift language is in flux and so this library may change significantly over time until Swift gets to a stable place.


### Installation

If you use CocoaPods:

##### Podfile
```ruby
pod "PapersPlease", "~> 0.3.0"
```

Or add the Classes directory to your project.


### The basics

Here's a basic example, creating a string length constraint which passes validation while the string is between 4 and 8 characters.

``` Swift
let length_type:ValidatorLengthType = ValidatorLengthType(minimumCharacters:4, maximumCharacters:8)

let unit:ValidationUnit = ValidationUnit(validatorTypes: [length_type], identifier: "unit")
[unit registerValidationType:length_type];

// get validation status update
NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("validationUnitStatusChange:"), name: ValidationUnitUpdateNotification, object: unit)
		
// listen for validation status updates    
@objc func validationUnitStatusChange(notification:NSNotification) {
    
    let unit:ValidationUnit = notification.object as ValidationUnit
    println("\(unit.identifier) is \(unit.valid)")
    
}

// validate the string 
unit.validateText("Velvet Underground")
```

That example only uses one validation type class, but you can add as many as you want to create very complex validation tests. Of course, power users may want to take advantage of the ValidatorRegexType class, which allows use of a regular expression as a validation test. For complex use cases this can be preferable – ValidatorEmailType uses a regular expression internally – but using more basic type classes together can provide greater readability. YMMV.

Validating static strings is cool, but let's hook up a ValidationUnit to a UITextField so we can dynamically validate it as its text changes. While we could do this with just a ValidationUnit, it's a bit easier to use ValidationManager for this.

``` Swift
let manager = ValidationManager()
let email_type:ValidatorEmailType = ValidatorEmailType()
manager.registerTextField(self.textField, validationTypes: [email_type], identifier: "email")
                                               
// register for validation status updates
NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("validationManagerStatusChange:"), name: ValidationStatusNotification, object: manager)
		
// listen for manager's validation updates
@objc func validationManagerStatusChange(notification:NSNotification) {
  let user_info = notification.userInfo as Dictionary
  let is_valid = (user_info["status"] as NSNumber).boolValue as Bool
  
  if (!is_valid) {
  	let all_errors:NSDictionary = user_info["errors"] as NSDictionary
  	let email_dict:NSDictionary = all_errors[email_type.identifier] as NSDictionary
  	let email_errors:NSDictionary = email_dict["errors"] as NSDictionary
  } 
    
}
```

## Credits

PapersPlease was created by [Brett Walker](https://twitter.com/petsound) of [Poet & Mountain](http://poetmountain.com).

## Compatibility

* Requires iOS 7.0 or later, Xcode 6+

## License

PapersPlease is licensed under the MIT License.