# Desk360

<p align="left">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5-orange.svg" alt="Swift"/></a>
  <a href="https://developer.apple.com/xcode"><img src="https://img.shields.io/badge/Xcode-10-blue.svg" alt="Xcode"></a>
  <a href="https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-red.svg" alt="MIT"></a>
</p>

## Table of Contents

- [Summary](#summary)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Support](#installation)
- [License](#license)

## Summary

Desk360 is an iOS SDK to help you embedding customer support in your iOS applications with ease!

## Features

- Create new support tickets.
- View and comment on existing tickets.
- Interactively communicate with related support teams.

## Installation

### Using CocoaPods

To integrate Desk360 in your Xcode project using [CocoaPods](https://cocoapods.org), specify it in your `Podfile`:

```ruby
pod 'Desk360'
```

## Usage

### Important footnot

You must add your info.plist file.
```
<key>NSPhotoLibraryUsageDescription</key>
<string>Allow the app to access your photos.</string>
```
Permission text is optional. you can type whatever you want. But this permission not optional. If you didn't add this permission. Desk360 Images attachment property doesn't work.

### Start Desk360 with appId -and an optinal deviceId, an optional language-

> Note: If no deviceId is provided, Desk360 will use device's [UUID](https://developer.apple.com/documentation/foundation/uuid), which might cause your app to lose tickets when the application is deleted. If no isDebug is provided, Desk360 will use false and Sdk looks at prod url. If no application language is provided, Desk360 will use device's language.

```swift
import Desk360

Desk360.start(appId: "12345")
Desk360.start(appId: "12345", deviceId: "34567", isDebug: false, language: "en")
```

### Using Desk360

```swift
import Desk360

class ExampleViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    Desk360.show(on: self, animated: true)
  }
  
}
```

### Customize Desk360 Theme

You should use [Desk360](https://desk360.com/) dashboard for custom config.

## Support

If you have any questions or feature requests, please [create an issue](https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk/issues/new).

## License

Desk360 is released under the MIT license. See [LICENSE](https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk/blob/master/LICENSE) for more information.
