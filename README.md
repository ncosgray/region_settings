# region_settings

A Flutter plugin to get device region settings such as measurement system and temperature units.

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
int firstDayOfWeek = regionSettings.firstDayOfWeek;
```

`temperatureUnits` is set to an enum with the following possible values:
| enum | value |
|-|-|
| TemperatureUnit.celsius | 'C' |
| TemperatureUnit.fahrenheit | 'F' |

`firstDayOfWeek` is an integer in the range 1..7, where 1 is Monday and 7 is Sunday. This value corresponds to the dart:core [DateTime weekday](https://api.dart.dev/stable/3.5.3/dart-core/DateTime/weekday.html) property, and can be compared to constants such as DateTime.monday, as demonstrated in the [example app](https://pub.dev/packages/region_settings/example).

## iOS Implementation

#### Measurement System and Temperature Units

This plugin accesses Language & Region settings on iOS. Users can specify a Temperature preference (degrees C or degrees F) and a Measurement System preference (US, UK, or Metric). For the purposes of this plugin, the UK Measurement System is considered equivalent to Metric.

Note that the Temperature preference is not always honored when running on iOS simulators; however, it is reported correctly on physical devices.

#### First Day of Week

iOS 16 and later add a First Day of Week preference to Language & Region. iOS allows selecting any of day of the week. To surface the user's first day of week preference, the First Day of Week setting is used by this plugin, if available. On older versions of iOS that lack this setting, the plugin falls back to assuming the first day of week based on the device's locale. See **Table of First Day of Week by Country** below.

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

Android 14 and later include a separate Temperature preference in Regional Preferences. If available, the plugin will use this setting. If not available, the plugin will fall back to the locale, where Metric countries are assumed to use Celsius and non-Metric countries are assumed to use Fahrenheit.

#### First Day of Week

Android 14 and later add a First Day of Week preference to Regional Preferences. Android allows selecting any of day of the week. To surface the user's first day of week preference, the First Day of Week setting is used by this plugin, if available. On older versions of Android that lack this setting, the plugin falls back to assuming the first day of week based on the device's locale. See **Table of First Day of Week by Country** below.

## Table of First Day of Week by Country

In most countries, Monday or Sunday are considered the first day of the week, with Friday or Saturday also used in some places. The following table shows how this plugin determines which countries use which day. This list was sourced from https://github.com/unicode-org/cldr.

| Monday | Friday | Saturday | Sunday |
|-|-|-|-|
| _All other countries_ | Maldives | American Samoa (US) | Antigua and Barbuda |
| | | Afghanistan | Australia |
| | | Algeria | Bahamas |
| | | Bahrain | Bangladesh |
| | | Djibouti | Belize |
| | | Egypt | Bhutan |
| | | Iran | Botswana |
| | | Iraq | Brazil |
| | | Jordan | Cambodia |
| | | Kuwait | Canada |
| | | Libya | China |
| | | Oman | Colombia |
| | | Qatar | Dominica |
| | | Sudan | Dominican Republic |
| | | Syria | El Salvador |
| | | United Arab Emirates | Ethiopia |
| | | | Guam (US) |
| | | | Guatemala |
| | | | Honduras |
| | | | Hong Kong |
| | | | India |
| | | | Indonesia |
| | | | Israel |
| | | | Jamaica |
| | | | Japan |
| | | | Kenya |
| | | | Laos |
| | | | Macau |
| | | | Malta |
| | | | Marshall Islands |
| | | | Mexico |
| | | | Mozambique |
| | | | Myanmar |
| | | | Nepal |
| | | | Nicaragua |
| | | | Pakistan |
| | | | Panama |
| | | | Paraguay |
| | | | Peru |
| | | | Philippines |
| | | | Portugal |
| | | | Puerto Rico |
| | | | Samoa |
| | | | Saudi Arabia |
| | | | Singapore |
| | | | South Africa |
| | | | South Korea |
| | | | Taiwan |
| | | | Thailand |
| | | | Trinidad and Tobago |
| | | | United States |
| | | | US Minor Outlying Islands |
| | | | US Virgin Islands |
| | | | Venezuela |
| | | | Yemen |
| | | | Zimbabwe |

If the above list of countries is found to be inaccurate, please submit an [issue](https://github.com/ncosgray/region_settings/issues) or [PR](https://github.com/ncosgray/region_settings/pulls).

## About

This plugin was written primarily to improve support for region defaults in [Cuppa](https://github.com/ncosgray/cuppa_mobile).

Author: [Nathan Cosgray](https://www.nathanatos.com)