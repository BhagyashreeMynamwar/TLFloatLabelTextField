# TLFloatLabelTextField

[![CI Status](http://img.shields.io/travis/Myanamwar/TLFloatLabelTextField.svg?style=flat)](https://travis-ci.org/Myanamwar/TLFloatLabelTextField)
[![Version](https://img.shields.io/cocoapods/v/TLFloatLabelTextField.svg?style=flat)](http://cocoapods.org/pods/TLFloatLabelTextField)
[![License](https://img.shields.io/cocoapods/l/TLFloatLabelTextField.svg?style=flat)](http://cocoapods.org/pods/TLFloatLabelTextField)
[![Platform](https://img.shields.io/cocoapods/p/TLFloatLabelTextField.svg?style=flat)](http://cocoapods.org/pods/TLFloatLabelTextField)

A TLFloatLabelTextField is the Swift implementation. UITextField and UITextView subclasses with placeholders that change into floating labels when the fields are populated with text.

![tlfloattextfielddemo](https://user-images.githubusercontent.com/35949138/35852020-b8be1322-0b4f-11e8-8a6b-2a9089f0fe1b.gif)



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation
TLFloatLabelTextField is a beautiful, flexible and customizable implementation of the space saving "Float Label Pattern".

You can install the TLFloatLabelField components two ways:

Add 'TLFloatLabelTextField' and 'TLFloatLabelTextView' files to your project and subclass your textfield and textview in Storyboard with TLFloatLabelTextField and TLFloatLabelTextView.

(or)

TLFloatLabelTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TLFloatLabelTextField'
```

Next, switch to the Attributes Inspector tab and set the necessary attributes to configure your text field or text view. The Placeholder attribute (or Hint in the case of a UITextView) defines the actual title which will be used for your field.

Using TLFloatLabelTextField via code works the same as you would do to set up a UITextField or UITextView instance. Simply create an instance of the class, set the necessary properties, and then add the field to your view.

For TextField

```
let customTextField = TLFloatLabelTextField(frame:parentView.bounds)
customTextField.placeholder = "Comments"
parentView.addSubview(customTextField)
```
For TextView

```
let customTextView = TLFloatLabelTextView(frame:parentView.bounds)
customTextView.placeholder = "Comments"
parentView.addSubview(customTextView)
```

## Credits
  This project derives inspiration from JVFloatLabeledTextField project.

## Author

Myanamwar, bhagyashree14mt@gmail.com

## License

TLFloatLabelTextField is available under the MIT license. See the LICENSE file for more info.
