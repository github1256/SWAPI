# SWAPIApp
Swift iOS app displaying Star Wars characters using SWAPI, the Star Wars API

Built using XCode 11.6 (Swift 5.1)

By [Priscilla Ip](mailto:priscillaplip@gmail.com)

[https://github.com/mcipswitch](https://github.com/mcipswitch)

## Installation
To run the app clone this [repository](https://github.com/mcipswitch/swapi-app). Clone locally using:

`git clone https://github.com/mcipswitch/swapi-app.git`

#### System Requirements
iOS version 13.0+

## Technologies

* Networking with URLSession
* [SWAPI](https://swapi.dev), the open Star Wars API
* UIKit and MVVM architecture
* XCTest for unit tests

## Take-Home Challenge Requirements

#### Write an iOS app in Swift or Objective-C that lists Star Wars characters using the open [API](https://swapi.dev) and targeted at iOS 13.0 +

SWAPIApp lists the names of all Star Wars characters in alphabetical order (using the `/api/people` endpoint). Selecting a name on the list opens a detail view that displays their *name*, *birth year*, and *physical attributes* (height, mass, hair color, skin color, eye color and gender). The detail view also includes the *name of all the films* the character appears in and also the *word count* of the `opening_crawl` attribute for each film.

This project follows the MVVM architectural pattern and features a pure UIKit solution with views written programmatically and with XIB files.

#### Additional

Unit tests were written using XCTest to test the networking calls with URLSession and to check that the word count string extension was returning the correct number of words in the `opening_crawl` attribute.

The app supports light/dark mode and landscape/portrait orientation.

## Screenshots

<p float="left">
  <img src="https://github.com/mcipswitch/swapi-app/blob/master/Screenshots/sw_launchscreen.png" width="250">
  <img src="https://github.com/mcipswitch/swapi-app/blob/master/Screenshots/sw_light_listview.png" width="250">
  <img src="https://github.com/mcipswitch/swapi-app/blob/master/Screenshots/sw_dark_listview.png" width="250">
  <img src="https://github.com/mcipswitch/swapi-app/blob/master/Screenshots/sw_light_detailsview.png" width="250">  
  <img src="https://github.com/mcipswitch/swapi-app/blob/master/Screenshots/sw_dark_detailsview.png" width="250">
</p>
