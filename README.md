# Desk360 iOS SDK

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
- [Support](#support)
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

### Using SPM

```swift
dependencies: [
    .package(url: "https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk", .branch("master"))
]
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

> Note: If no deviceId is provided, Desk360 will use device's [UUID](https://developer.apple.com/documentation/foundation/uuid), which might cause your app to lose tickets when the application is deleted. If use environment type .production, Desk360 will look at prod url. If no application language is provided, Desk360 will use device's language.

```swift
import Desk360

let props = Desk360Properties(appKey: "1234")

// Or if you would like to provide more info here is a full list of the params
let props = Desk360Properties(
        appKey: "1234",
        deviceID: "34567",
        environment: .production,
        language: "en",
        country: "TR",
        userCredentials: .init(name: "John Doe", email: "john@doe.com"),
        bypassCreateTicketIntro: true,
        jsonInfo: ["a": 500, "b": "c"]
    )

Desk360.start(using: props)
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

### Using Optional Notification System
If you need to send a notification when a message is sent to the users. You have to do this integration.


```swift
import Desk360

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       Desk360.setPushToken(deviceToken: deviceToken)
  }
  
}
```
After the above integration, it is sufficient to make the notification certificate settings in the [Desk360](https://desk360.com/) admin panel. You can now use notifications

Also if you want notification redirect deeplink system. You should some extra integration.


```swift
import Desk360

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
      Desk360.applicationLaunchChecker(launchOptions)
      if #available(iOS 10.0, *) {
          let center = UNUserNotificationCenter.current()
          center.delegate = self
      }
      return true
      
    }
}


// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert])
      Desk360.willNotificationPresent(notification.request.content.userInfo)
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      Desk360.applicationUserInfoChecker(userInfo)
  }
  
  @available(iOS 10.0, *)
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      Desk360.applicationUserInfoChecker(response.notification.request.content.userInfo)
  }
}
```

When you click on the notification when your application is closed, you need to add this code on which page you want Des360 to open.

```swift
import Desk360

final class YourMainViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    Desk360.showWithPushDeeplink(on: self)
  }

}
```


### Getting the unread tickets
If you would like to get a list of the unread tickets you can do so like follows:
```swift
  Desk360.getUnreadTickets { results in
			switch results {
			case .failure(let error):
				print(error.localizedDescription)
			case .success(let tickets):
				print("Tickets: \(tickets.count)")
			}	
	}
```

You can show the unread tickets the way that fits your app design and expierence. If you want to navigate to a specific ticket 
detail you can do so so by following:

```swift
  let detailsViewController = Desk360.ticketDetailsViewController(ofTicket: unreadTicket)
	self.present(detailsViewController, animated: true, completion: nil)
```

### Customize Desk360 Theme

You should use [Desk360](https://desk360.com/) dashboard for custom config.

## Support

If you have any questions or feature requests, please [create an issue](https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk/issues/new).

## License

Desk360 is released under the MIT license. See [LICENSE](https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk/blob/master/LICENSE) for more information.
