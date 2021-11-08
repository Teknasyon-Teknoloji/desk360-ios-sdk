## Version 1.8.5

* **Features**
  + Added support for opening PDF docuements in a seperate view controller.
* **Bug Fixes**
  + Fix the performance issue for attachmnet views.

## Version 1.8.4

* **Features**
  + Added support for PDF docuements caching.
* **Bug Fixes**
  + Fix the issue that casuses the input view to be resigned when scrollling.
  + Fix an issue preventing the SDK from opening correctly.

## Version 1.8.3

* **Bug Fixes**
  + Fix the email and name characters count labels layout.
  

## Version 1.8.2

* **Bug Fixes**
  + Fix the compilation issue in Xcode13.
  

## Version 1.8.1

* **Bug Fixes**
  + Prevents possible crashes when the extra json data parameter passed as nil.
  

## Version 1.8.0

* **Features**
  + Add the ability to get and present the unread tickets.
  

## Version 1.7.2

* **Minor Changes**
  + Improved Deelplinking experience. 

## Version 1.7.0

* **Features**
  + Add the ability to bypass the intro screen that is shown before ticket creation screen.
  + Add the ability to hide the DESK360 logo.

* **Bug Fixes**
  + Fix popover presentation on iPad.
  + Fix ticket cell title layout on iPad.
  + Fix privacy policy agreement text color.

* **Breaking Changes**
  + Introduced `Desk360Properties` to eliminate giant parameter list in `start` method.

## Version 1.6.0

* **Minor Changes**
  + Update Moya dependency

## Version 1.5.1

* **Minor Changes**
  + Changed the order of the args in `start` method.

## Version 1.5.0

* **Features**
  + Add the ability to provide the current logged-in user name and email as default arguments.

* **Bug Fixes**
  + Fix push notifications deeplinking to the related ticket.
