PapersPlease is a modular, extendable text validation library for iOS, written in Apple's Swift language. The Objective-C version of this library is [PMValidation](https://github.com/poetmountain/PMValidation/). PapersPlease comes with several common validation types for often-used tasks like validating registration forms, however it was architected to be easily extended with your own validation types.

## Features

* Validate individual string objects or listen to changes from UIKit objects
* Modular – validation types can be used together to create complex validation constraints
* Extensible - Easily create your own validation types by subclassing PMValidationType
* Comes with several useful validation types to satisfy most validation needs
* Easily implement form validation by using ValidationManager to register UITextField and UITextView objects

## Overview

At its simplest, PapersPlease starts with an instance of ValidationUnit. Each ValidationUnit controls one or more ValidatorType objects, and ValidationUnit provides an overall validation state for the types registered with it. All validation types are subclasses of ValidatorType, and you can do the same to easily create your own validator types. 

Generally, a ValidationUnit handles the validation of one text object. When you are validating more than one text object, such as with a validation form, the ValidationManager class is useful. This class controls one or more ValidationUnit objects, providing an overall validation status and notification routing.

### The basics

Here's a basic example, creating a string length constraint which passes validation while the string is between 4 and 8 characters.

``` swift
PMValidationLengthType *length_type = [PMValidationLengthType validator];
length_type.minimumCharacters = 4;
length_type.maximumCharacters = 8;

PMValidationUnit *unit = [PMValidationUnit validationUnit];
[unit registerValidationType:length_type];

// get validation status update
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validationStatusNotificationHandler:) name:PMValidationUnitUpdateNotification object:unit];
		
// listen for validation status updates    
- (void)validationStatusNotificationHandler:(NSNotification *)notification {
    
  PMValidationUnit *unit = (PMValidationUnit *)notification.object;

  if (!unit.isValid) {
  	NSDictionary *errors = [notification.userInfo valueForKey:@"errors"];
  }  
    
}


// validate the string 
[unit validateText:@"Velvet Underground"];
```

That example only uses one validation type class, but you can add as many as you want to create very complex validation tests. Of course, power users may want to take advantage of the PMValidationRegexType class, which allows use of a regular expression as a validation test. For complex use cases this can be preferable – PMValidationEmailType uses a regular expression internally – but using more basic type classes together can provide greater readability. YMMV.

Validating static strings is cool, but let's hook up a PMValidationUnit to a UITextField so we can dynamically validate it as its text changes. While we could do this with just a PMValidationUnit, it's a bit easier to use PMValidationManager for this.

```objective-c
PMValidationManager *manager = [PMValidationManager validationManager];
PMValidationEmailType *email_type = [PMValidationEmailType validator];
PMValidationUnit *email_unit = [manager registerTextField:self.emailTextField
                                       forValidationTypes:[NSSet setWithObjects:email_type, nil]
                                               identifier:@"email"];
                                               
// get validation status update
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validationStatusNotificationHandler:) name:PMValidationStatusNotification object:self.validationManager];
		
    
- (void)validationStatusNotificationHandler:(NSNotification *)notification {
    
  BOOL is_valid = [(NSNumber *)[notification.userInfo objectForKey:@"status"] boolValue];
  if (!is_valid) {
  	NSDictionary *units = [notification.userInfo objectForKey:@"units"];
  	NSDictionary *email_dict = [units objectForKey:email_type.identifier];
  	NSDictionary *email_errors = [email_dict objectForKey:@"errors"];
  } 
    
}
```