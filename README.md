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

### Post Address

Save an address record and get back an id

``swift
let address = EasyPostAddress()

address.name = "Johnny Appleseed"
address.company = "Apple"
address.street1 = "1 Infinite Loop"
address.street2 = "Suite 1"
address.city = "Cupertino"
address.state = "CA"

EasyPostApi.sharedInstance.postAddress(address) { (result) -> () in
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        switch(result) {
        case .Success(let value):
            
            print("Successfully posted address.")
            
        case .Failure(let error):
            print("Error posting address: \((error as NSError).localizedDescription)")
        }
    })
}
```
### Post Shipment

Save a shipment record with a to address, from address, and parcel

```swift
let toAddress = EasyPostAddress()
toAddress.name = "Johnny Appleseed"
toAddress.company = "Apple"
toAddress.street1 = "1 Infinite Loop"
toAddress.street2 = "Suite 1"
toAddress.city = "Cupertino"
toAddress.state = "CA"

let fromAddress = EasyPostAddress()
fromAddress.name = "Johnny Appleseed"
fromAddress.company = "Apple"
fromAddress.street1 = "1 Infinite Loop"
fromAddress.street2 = "Suite 1"
fromAddress.city = "Cupertino"
fromAddress.state = "CA"

let parcel = EasyPostParcel()
parcel.length = NSNumber(float:10.0)	//inches
parcel.width = NSNumber(float:10.0)		//inches
parcel.height = NSNumber(float:10.0)	//inches
parcel.weight = NSNumber(float:10.0)	//ounces

EasyPostApi.sharedInstance.postShipment(toAddress, fromAddress: fromAddress, parcel: parcel) { (result) -> () in
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        switch(result) {
        case .Success(let shipment):
            
            print("Successfully posted shipment.")
            
            if let id = shipment.id {
                print("Shipment id: \(id)")
            }
            
        case .Failure(let error):
            print("Error posting shipment: \((error as NSError).localizedDescription)")
        }
    })
}
```

## Author

[William Welbes](http://www.twitter.com/welbes)

## License

EasyPostApi is available under the MIT license. See the LICENSE file for more info.
