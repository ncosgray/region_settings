# region_settings

Flutter plugin to get device region settings.

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|✅|✅|||||

## Usage

Call `RegionSettings` to access device region settings including temperature unit and measurement system preferences:

```dart
import 'package:region_settings/region_settings.dart';

final regionSettings = RegionSettings();
TemperatureUnit getTemperatureUnits = await regionSettings.getTemperatureUnits();
bool usesMetricSystem = await regionSettings.usesMetricSystem();
```

`getTemperatureUnits` returns an enum with the following possible values:
| enum | value |
|-|-|
| TemperatureUnit.celsius | 'C' |
| TemperatureUnit.fahrenheit | 'F' |

## iOS

This plugin accesses Language & Region settings on iOS. Users can specify a Temperature preference (degrees C or degrees F) and a Measurement System preference (US, UK, or Metric). For the purposes of this plugin, the UK Measurement System is considered equivalent to Metric.

Note that the Temperature preference is not honored when running on iOS simulators; however, it is reported correctly on physical devices.

## Android

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

All other countries are considered to be Metric users. If the above list of countries is found to be inaccurate, please submit an issue or PR.

Android 14+ includes a separate Temperature preference in Regional Preferences. If available, the plugin will use this setting. If not available, the plugin will fall back to the locale, where Metric countries are assumed to use Celsius and non-Metric countries are assumed to use Fahrenheit.