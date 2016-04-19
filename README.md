# syncano-apns-example

## Overview
---

This application is a demo for push notifications on Syncano platform for iOS.

## Configuration
---

Please set proper API-KEY (with user creation permission) and instance name in AppDelegate.swift:
```
let syncano = Syncano.sharedInstanceWithApiKey("api-key", instanceName: "instance-name")
```
