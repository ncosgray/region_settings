# region_settings

A Flutter plugin to get device region settings such as measurement system, temperature units, and date/number formats.

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|✅|✅|||||

## Usage

To use this plugin, add `region_settings` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

Call `RegionSettings` to access device region settings including temperature unit, measurement system, and date/number format preferences. The plugin also offers [Date and Number Formatters](#date-and-number-formatters).

```dart
import 'package:region_settings/region_settings.dart';

final RegionSettings regionSettings = await RegionSettings.getSettings();

TemperatureUnit temperatureUnits = regionSettings.temperatureUnits;
// US default: TemperatureUnit.fahrenheit
// UK default: TemperatureUnit.celsius
// FR default: TemperatureUnit.celsius

bool usesMetricSystem = regionSettings.usesMetricSystem;
// US default: false
// UK default: true
// FR default: true

int firstDayOfWeek = regionSettings.firstDayOfWeek;
// US default: 7
// UK default: 1
// FR default: 1

String dateFormatShort = regionSettings.dateFormat.short;
// US default: M/d/yy
// UK default: dd/MM/y
// FR default: dd/MM/y

String dateFormatMedium = regionSettings.dateFormat.medium;
// US default: MMM d, y
// UK default: d MMM y
// FR default: d MMM y

String dateFormatLong = regionSettings.dateFormat.long;
// US default: MMMM d, y
// UK default: d MMMM y
// FR default: d MMMM y

String numberFormatInteger = regionSettings.numberFormat.integer;
// US default: #,###,###
// UK default: #,###,###
// FR default: # ### ###

String numberFormatDecimal = regionSettings.numberFormat.decimal;
// US default: #,###,###.##
// UK default: #,###,###.##
// FR default: # ### ###,##

String decimalSeparator = regionSettings.decimalSeparator;
// US default: .
// UK default: .
// FR default: ,

String groupSeparator = regionSettings.groupSeparator;
// US default: ,
// UK default: ,
// FR default: <space>
```

`temperatureUnits` is set to an enum with the following possible values:
| enum | value |
|-|-|
| TemperatureUnit.celsius | 'C' |
| TemperatureUnit.fahrenheit | 'F' |

`firstDayOfWeek` is an integer in the range 1..7, where 1 is Monday and 7 is Sunday. This value corresponds to the dart:core [DateTime weekday](https://api.dart.dev/stable/3.5.3/dart-core/DateTime/weekday.html) property, and can be compared to constants such as DateTime.monday, as demonstrated in the [example app](https://pub.dev/packages/region_settings/example).

The three `dateFormat` values are the date formatting patterns used by the device's locale and/or region settings. For example, the UK English short date format is typically 'dd/MM/y', while US English uses 'MM/dd/y'. Pass the date format pattern to a function like [intl DateFormat](https://pub.dev/packages/intl) to use this in a Flutter app. Or, use the `formatDate` convenience method provided by this plugin.

The `numberFormat` values are the number formatting patterns used by the device's locale and/or region settings. This includes group separator characters. For example, US and UK English typically use decimal number format '#,###,###.##', while in France '# ### ###,##' is the default. Unfortunately, not all number format patterns work with [intl NumberFormat](https://pub.dev/packages/intl), so it is not recommended to pass the pattern directly to NumberFormat. Instead, use the `formatNumber` method provided by this plugin.

## Date and Number Formatters

#### formatDate

After calling `getSettings` to load the platform settings, use this convenience method to format a date (using [intl DateFormat](https://pub.dev/packages/intl) behind the scenes) with the device locale and regional preferences applied. This allows you to format a date without needing to manually specify the formatting pattern or manage the locale.

*Parameters:*
* `date` - The date to format.
* `dateStyle` - Specify the date style. Defaults to `DateStyle.medium`.

*Example:*
```dart
import 'package:region_settings/region_settings.dart';

final RegionSettings regionSettings = await RegionSettings.getSettings();

String todayFormattedAsLongDate = regionSettings.formatDate(
    DateTime.now(),
    dateStyle: DateStyle.long,
);
// US default: January 1, 2025
// UK default: 1 January 2025
// FR default: 1 janvier 2025
```

`DateStyle` is an enum defined by this plugin and has the following possible values corresponding to `dateFormat` options:
| DateStyle | dateFormat |
|-|-|
| DateStyle.short | dateFormat.short |
| DateStyle.medium | dateFormat.medium |
| DateStyle.long | dateFormat.long |

#### formatNumber

After calling `getSettings` to load the platform settings, use this convenience method to format a number with the regional preferences applied. The formatter is [intl NumberFormat](https://pub.dev/packages/intl), but the plugin overrides separator characters and grouping styles as defined by the device's region settings. This allows you to format a number without needing to manually specify the formatting pattern or manage the locale.

*Parameters:*
* `number` - The number to format.
* `decimalPlaces` - Specify an exact number of decimal places to show.
* `significantDigits` - Specify the number of significant digits.
* `minimumFractionDigits` - Specify minimum decimal places to show.
* `maximumFractionDigits` - Specify maximum decimal places to show.
* `useGrouping` - Separate into groups (e.g. thousands). Defaults to true.
* `asPercentage` - Formats the number as a percentage. Defaults to false.

 If `decimalPlaces` is specified, it overrides any values provided as minimum and/or maximum fraction digits. If none of `decimalPlaces`, `minimumFractionDigits`, or `maximumFractionDigits` are specified, the number is formatted according to locale defaults.

*Example:*
```dart
import 'package:region_settings/region_settings.dart';

final RegionSettings regionSettings = await RegionSettings.getSettings();

String speedOfLightFormatted = regionSettings.formatNumber(
    299792458,
    decimalPlaces: 1,
    useGrouping: true,
);
// US default: 299,792,458.0
// UK default: 299,792,458.0
// FR default: 299 792 458,0
```

## iOS Implementation

#### Measurement System and Temperature Units

This plugin accesses Language & Region settings on iOS. Users can specify a Temperature preference (degrees C or degrees F) and a Measurement System preference (US, UK, or Metric). For the purposes of this plugin, the UK Measurement System is considered equivalent to Metric.

Note that the Temperature preference is not always honored when running on iOS simulators; however, it is reported correctly on physical devices.

#### First Day of Week

iOS 16 and later add a First Day of Week preference to Language & Region. iOS allows selecting any of day of the week. To surface the user's first day of week preference, the First Day of Week setting is used by this plugin, if available. On older versions of iOS that lack this setting, the plugin falls back to assuming the first day of week based on the device's locale. See **Table of First Day of Week by Country** below.

#### Date and Number Formats

The plugin gets date and number format patterns from iOS. On older versions of iOS, the format patterns depend on the device's language setting. iOS 16 and later add Date Format and Number Format preferences to Language & Region, which allows the user to change the formats independently of the language's defaults, including the separator characters.

## Android Implementation

#### Measurement System

Android 16 and later include a separate Measurement System preference in Regional preferences. If available, the plugin will use this setting. If not available, the plugin must guess the measurement system based on the device's locale. The plugin considers the following countries to be non-Metric:
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

#### Date Format

Android date formats are based on the device's locale. However, fetching the date format pattern is only possible in API 26 (Oreo) and later. The plugin will do this on supported versions of Android. On older versions of Android, the plugin falls back to standard patterns that should be recognizable worldwide, such as 'yyyy-MM-dd' for the short date.

#### Number Format

Android number formats are based on the device's locale using standard Java NumberFormat methods.

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