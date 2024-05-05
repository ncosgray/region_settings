# region_settings

Flutter plugin to get device region settings.

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|✅|✅|||||

## Usage

To use this plugin, add `region_settings` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

Call `RegionSettings` to access device region settings including temperature unit and measurement system preferences:

```dart
import 'package:region_settings/region_settings.dart';

final RegionSettings regionSettings = await RegionSettings.getSettings();
TemperatureUnit temperatureUnits = regionSettings.temperatureUnits;
bool usesMetricSystem = regionSettings.usesMetricSystem;
```

`temperatureUnits` is set to an enum with the following possible values:
| enum | value |
|-|-|
| TemperatureUnit.celsius | 'C' |
| TemperatureUnit.fahrenheit | 'F' |

## iOS Implementation

This plugin accesses Language & Region settings on iOS. Users can specify a Temperature preference (degrees C or degrees F) and a Measurement System preference (US, UK, or Metric). For the purposes of this plugin, the UK Measurement System is considered equivalent to Metric.

Note that the Temperature preference is not honored when running on iOS simulators; however, it is reported correctly on physical devices.

## Android Implementation

#### Measurement System

Android does not have an OS-level measurement system setting. Instead, the plugin must guess the measurement system based on the device's locale. The plugin considers the following countries to be non-Metric:
* American Samoa (US)
* Bahamas
* Belize
* Cayman Islands
* Guam (US)
* Liberia
* Marshall Islands
* Micronesia
* Northern Mariana Islands (US)
* Palau
* Turks and Caicos Islands
* United States
* US Minor Outlying Islands
* US Virgin Islands

All other countries are considered to be Metric users.

If the above list of countries is found to be inaccurate, please submit an [issue](https://github.com/ncosgray/region_settings/issues) or [PR](https://github.com/ncosgray/region_settings/pulls).

#### Temperature Units

Android 14+ includes a separate Temperature preference in Regional Preferences. If available, the plugin will use this setting. If not available, the plugin will fall back to the locale, where Metric countries are assumed to use Celsius and non-Metric countries are assumed to use Fahrenheit.

## About

This plugin was written primarily to improve support for region defaults in [Cuppa](https://github.com/ncosgray/cuppa_mobile).

Author: [Nathan Cosgray](https://www.nathanatos.com)