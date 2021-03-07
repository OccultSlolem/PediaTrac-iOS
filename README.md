# PediaTrac-iOS - SF Hacks 2021

[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]

<p align="center">
 An app to find when you should take your newborn to the pediatrician
</p>

<p align="row">
<img src="https://media.giphy.com/media/qZHo1TClS4zJLPBg1L/giphy.gif" width="400">
<img src="https://media.giphy.com/media/pvQbJOdwaakj9znTk1/giphy.gif" width="400">
</p>

## Features

- [x] Calculate recommended appointments and vaccines based on child's age
- [x] Age appointments to calendar
- [x] Sync information online for easy access on multiple devices
- [x] Localization options for English and Spanish

## Requirements
- iOS 14.4+
- Xcode 12.4+

## Setup

### Installation onto an iPhone - Simple

1. Connect your iPhone using a lightning cable
2. Install the latest binary (.ipa file)
3. Open Xcode
4. Press cmd+shift+2 to bring up the devices window
5. Drag and drop the .ipa file onto your iPhone


### Installation - Manual/Simulator

1. Clone this repository onto your computer

``git clone https://github.com/OccultSlolem/PediaTrac-iOS.git``

2. Open InfluPeach.xcworkspace in Xcode
3. Next to the run button in the top left corner, select the target you want to use (can be your iPhone connected through lightning cable or a simulator)
4. Click run

Instructions may vary if you are using a different IDE (like Appcode)

### Firebase

The app uses Firebase to store and authenticate user accounts. Currently it uses the Firebase project on my personal Google account. If you want to create your own Firebase project on your own profile, follow these steps.

1. Go to firebase.google.com and click "Go to console" in the upper right corner
2. Follow the steps to set up your profile and create your first project
3. Create an iOS app and make sure the bundle identifier is set to com.influpeach.ios
4. Remove the ``GoogleService-Info.plist`` file inside the InfluPeach folder and replace it with the one provided to you

### Other setup

Inside PediaTrac -> HelperScripts are some scripts that hold settings that are referenced by the views in this project several times, including
- ``TermsPrivacy.swift``: Includes links to your Terms & Conditions and Privacy Policy. Referenced by the sign up view (the links in the view will correspond to what links you set them to in this file)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE