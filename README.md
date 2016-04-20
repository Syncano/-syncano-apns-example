# syncano-apns-example

## Overview
---

This application is a demo for push notifications on Syncano platform for iOS.

## Installation
---

* `git clone <repository-url>` this repository
* `pod install`
* `open apns-example.xcworkspace`
* Set proper API-KEY (with user creation permission) and instance name in AppDelegate.swift:
```
let syncano = Syncano.sharedInstanceWithApiKey("api-key", instanceName: "instance-name")
```

* Setup certificates, provisioning profile and corresponding Bundle Identifier - read [Syncano Docs iOS - APNs Socket Configuration](http://docs.syncano.io/v1.1/docs/push-notification-sockets-ios)

## Features
---

* Login existing user or register new one
* Register device for notifications
* Receive and display notifications

## About
---

* Device token is obtained in AppDelegate.
* ViewController logs existing user or creates new user and registers new device
* NotificationsViewController displays new notifications received via NSNotificationCenter from AppDelegate

## Links
---
* [Syncano Docs iOS - APNs Socket Configuration](http://docs.syncano.io/v1.1/docs/push-notification-sockets-ios)
* [Syncano HTTP API Reference - APNS Config - details](http://docs.syncano.io/v6/docs/apns-config-details)
* [iOS Developer Library - About Local and Remote Notifications] (https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/Introduction.html#//apple_ref/doc/uid/TP40008194-CH1-SW1)
