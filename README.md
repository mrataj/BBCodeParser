# BBCodeParser

[![CI Status](http://img.shields.io/travis/mrataj/BBCodeParser.svg?style=flat)](https://travis-ci.org/mrataj/BBCodeParser)
[![Version](https://img.shields.io/cocoapods/v/BBCodeParser.svg?style=flat)](http://cocoapods.org/pods/BBCodeParser)
[![License](https://img.shields.io/cocoapods/l/BBCodeParser.svg?style=flat)](http://cocoapods.org/pods/BBCodeParser)
[![Platform](https://img.shields.io/cocoapods/p/BBCodeParser.svg?style=flat)](http://cocoapods.org/pods/BBCodeParser)

## Usage

BBCodeParser is open source objective C library for parsing BBCode (Bulletin Board Code).

To use this library in your project, copy files in BBCodeParser folder into your project. Then, include "BBCodeParser.h" file wherever you want to parse your code.

Usage example:

```objective-c
NSString *code = @""; // Your BB code here ...
BBCodeParser *parser = [[BBCodeParser alloc] initWithString:code];
for (BBElement *element in parser.elements)
{
// ...
}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BBCodeParser is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BBCodeParser"
```

## Author

Miha Rataj, rataj.miha@gmail.com

## License

BBCodeParser is available under the MIT license. See the LICENSE file for more info.
