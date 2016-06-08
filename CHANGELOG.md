0.3.2
=====
* Fixed public access issues outside Module context

0.3.1
=====
* Swift 2.2 compatibility
* Other bugfixes

0.3.0
=====
* Swift 2.0 compatibility
* Updated demo project for compatibility

0.2.2
=====
* Swift 1.2 compatibility

0.2.1
=====
* Changes for compatibility with Swift 1.2 beta 1

0.2.0
=====
__Feature compatibility with PMValidation 1.3.1__
* Added ability to add and remove ValidationUnit instances from a ValidationManager instance using the new addUnit() and removeUnitForIdentifier() methods.
* Added enabled boolean property to ValidationUnit, which disables validation when set to NO. ValidationManager will skip units thusly disabled and not count them toward the global validation state.

* Fixed potential retain cycle in ValidationUnit's validateText() method.

0.1.4
=====
* Swift 1.1 compatibility

0.1.3
=====
* Changes for Swift updates in Xcode 6 beta 5.

0.1.2
=====
* Changes to maintain compatibility with Swift updates in Xcode 6 beta 4. Also removed dispatch_release in ValidationUnit.

0.1.1
=====
* Updates due to Xcode 6 beta 3's changes to Swift.

0.1.0
=====
Initial release. As the Swift language is still in flux, I've used a sub-1.0 version to denote that this library may change significantly over time as the language does. As it stands now though, it does function as advertised.
