# CarthageSupport

It is a tool to automate manual work in xcode which is done when installing library with carthage.This tool will make the following settings.  

- Generate Cartfile
- Settings Linked Frameworks and Libraries
- Settings Run script
- Setting Framework Search Path

## Installation

```ruby
gem 'carthage_support'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carthage_support

## Usage

carthage.yml
```
project_path:
  MyApp.xcodeproj

github "Alamofire/Alamofire":
  - Alamofire.framework
```

execute
```
$ cd /path/to/project_root
$ carthage_support setup
・・・
$ carthage update
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

