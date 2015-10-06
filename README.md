# EasyPostApi

[![Version](https://img.shields.io/cocoapods/v/EasyPostApi.svg?style=flat)](http://cocoapods.org/pods/EasyPostApi)
[![License](https://img.shields.io/cocoapods/l/EasyPostApi.svg?style=flat)](http://cocoapods.org/pods/EasyPostApi)
[![Platform](https://img.shields.io/cocoapods/p/EasyPostApi.svg?style=flat)](http://cocoapods.org/pods/EasyPostApi)

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / watchOS 2
- Xcode 7.0+

## Installation

EasyPostApi is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EasyPostApi',  '~> 0.1'
```

## Usage

This library uses the EasyPost JSON api.  Details about interacting with the EasyPost api can be found at [http://www.easypost.com/docs](http://www.easypost.com/docs)

### Set Credentials

Call the set credentials method on a shared instance of the API manager before any susequent calls.  You only need to call this method once a shared instance as it maintains the credentials across calls.

```swift
	let apiToken = "YOUR-TOKEN"
	EasyPostApi.sharedInstance.setCredentials(apiToken, baseUrl: "https://api.easypost.com/v2/")
```

## Author

[William Welbes](http://www.twitter.com/welbes)

## License

EasyPostApi is available under the MIT license. See the LICENSE file for more info.
