/*
 *******************************************************************************
 Package:  region_settings
 Class:    region_settings.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.
 *******************************************************************************
*/

import 'region_settings_platform_interface.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:intl/number_symbols.dart';

/// Temperature unit options enum.
///
/// | enum | value |
/// |-|-|
/// | TemperatureUnit.celsius | 'C' |
/// | TemperatureUnit.fahrenheit | 'F' |
enum TemperatureUnit {
  /// Celsius units
  celsius('C'),

  /// Fahrenheit units
  fahrenheit('F');

  /// The enum value is 'C' or 'F'.
  final String value;

  const TemperatureUnit(this.value);

  /// Output temperature unit as a formatted string.
  @override
  String toString() {
    return 'TemperatureUnit.$name';
  }
}

/// Date format styles enum.
///
/// This enum defines three styles of date formats that can be used with
/// [RegionSettings.formatDate] or [RegionDateFormats]:
/// * short
/// * medium
/// * long
enum DateStyle {
  /// Short date format, e.g. M/d/yy.
  short,

  /// Medium date format, e.g. MMM d, y.
  medium,

  /// Long date format, e.g. MMMM d, y.
  long
}

/// Date format options.
///
/// This class contains three string fields corresponding to three different
/// styles of date formats:
/// * short
/// * medium
/// * long
class RegionDateFormats {
  /// Constructs an instance of date format options.
  RegionDateFormats({
    required this.short,
    required this.medium,
    required this.long,
  });

  /// Short date format, e.g. M/d/yy.
  final String short;

  /// Medium date format, e.g. MMM d, y.
  final String medium;

  /// Long date format, e.g. MMMM d, y.
  final String long;

  /// Get the date format pattern for a given DateStyle.
  String pattern(DateStyle style) {
    switch (style) {
      case DateStyle.short:
        return short;
      case DateStyle.medium:
        return medium;
      case DateStyle.long:
        return long;
    }
  }

  /// Output date format options as a formatted string.
  @override
  String toString() {
    return '''RegionDateFormats(
      short: '$short',
      medium: '$medium',
      long: '$long',
    )''';
  }
}

/// Number format options.
///
/// This class contains two string fields corresponding to two different styles
/// of number formats:
/// * integer
/// * decimal
class RegionNumberFormats {
  /// Constructs an instance of number format options.
  RegionNumberFormats({
    required this.integer,
    required this.decimal,
  });

  /// Integer number format, e.g. #,###,###.
  final String integer;

  /// Decimal number format, e.g. #,###,###.##.
  final String decimal;

  /// Output number format options as a formatted string.
  @override
  String toString() {
    return '''RegionNumberFormats(
      integer: '$integer',
      decimal: '$decimal',
    )''';
  }
}

/// Regional settings data.
///
/// Call [RegionSettings] to access device region settings including
/// temperature unit, measurement system, and date/number format preferences.
class RegionSettings {
  /// Constructs an instance of regional settings data.
  RegionSettings({
    required this.locale,
    required this.temperatureUnits,
    required this.usesMetricSystem,
    required this.firstDayOfWeek,
    required this.dateFormat,
    required this.numberFormat,
    required this.icuNumberFormat,
    required this.decimalSeparator,
    required this.groupSeparator,
  });

  /// The locale for the region settings.
  final String locale;

  /// Temperature unit options enum.
  final TemperatureUnit temperatureUnits;

  /// Boolean indicating if the device is set to use Metric.
  final bool usesMetricSystem;

  /// Integer denoting the first day of the week.
  final int firstDayOfWeek;

  /// Date format options.
  final RegionDateFormats dateFormat;

  /// Number format options.
  final RegionNumberFormats numberFormat;

  /// ICU standard number format pattern.
  ///
  /// This is a string that can be used with
  /// [intl NumberFormat](https://pub.dev/packages/intl) to format numbers.
  final String icuNumberFormat;

  /// The character used to separate decimal places in numbers.
  final String decimalSeparator;

  /// The character used to separate groups of thousands/hundreds in numbers.
  final String groupSeparator;

  /// Constants related to default format patterns.
  static const String _defaultDecimalSeparator = '.';
  static const String _defaultGroupSeparator = ',';
  static const String _nonDigitRegex = r'[^#0]';
  static const String _numberSymbolsName = 'regionsettings';

  /// Load all available regional settings from the device settings.
  ///
  /// Returns a [RegionSettings] object containing the current regional
  /// settings for temperature units, metric system use, first day of the week,
  /// date format patterns, and number format patterns.
  static Future<RegionSettings> getSettings() async {
    // Get regional settings from platform
    TemperatureUnit temperatureUnits = await getTemperatureUnits();
    bool usesMetricSystem = await getUsesMetricSystem();
    int firstDayOfWeek = await getFirstDayOfWeek();
    List<String> dateFormatsList = await getDateFormatsList();
    List<String> numberFormatsList = await getNumberFormatsList();
    String decimalSeparator =
        _findLastNonDigit(numberFormatsList[1]) ?? _defaultDecimalSeparator;
    String groupSeparator =
        _findFirstNonDigit(numberFormatsList[1]) ?? _defaultGroupSeparator;
    String icuNumberFormat = _getIcuNumberFormat(
        numberFormatsList[1], decimalSeparator, groupSeparator);

    // Initialize intl for date and number formatting
    await initializeDateFormatting();
    String locale = await findSystemLocale();
    Intl.defaultLocale = locale;
    _setNumberSymbols(
        locale, icuNumberFormat, decimalSeparator, groupSeparator);

    return RegionSettings(
      locale: locale,
      temperatureUnits: temperatureUnits,
      usesMetricSystem: usesMetricSystem,
      firstDayOfWeek: firstDayOfWeek,
      dateFormat: RegionDateFormats(
        short: dateFormatsList[0],
        medium: dateFormatsList[1],
        long: dateFormatsList[2],
      ),
      numberFormat: RegionNumberFormats(
        integer: numberFormatsList[0],
        decimal: numberFormatsList[1],
      ),
      icuNumberFormat: icuNumberFormat,
      decimalSeparator: decimalSeparator,
      groupSeparator: groupSeparator,
    );
  }

  /// Format a date using the regional settings.
  ///
  /// Returns the formatted [String] representation of a [DateTime] with the
  /// plaform's locale and regional settings preferences applied. This is a
  /// convenience method that uses the [intl DateFormat](https://pub.dev/packages/intl)
  /// class to format the date without needing to manually specify the pattern.
  ///
  /// Before using this method, ensure that [getSettings] has been called to
  /// load the plaform settings.
  ///
  /// Parameters:
  /// * [date] - The date to format.
  /// * [dateStyle] - Specify the date style. Defaults to [DateStyle.medium].
  String formatDate(
    DateTime date, {
    DateStyle dateStyle = DateStyle.medium,
  }) {
    String pattern;
    switch (dateStyle) {
      case DateStyle.short:
        pattern = dateFormat.short;
        break;
      case DateStyle.medium:
        pattern = dateFormat.medium;
        break;
      case DateStyle.long:
        pattern = dateFormat.long;
        break;
    }

    DateFormat formatter = DateFormat(pattern, locale);
    return formatter.format(date);
  }

  /// Format a number using the regional settings.
  ///
  /// Returns a formatted [String] representation of the number with the
  /// plaform's regional settings preferences applied. Separator characters and
  /// grouping styles are determined by the device's locale and region settings.
  ///
  /// If none of [decimalPlaces], [minimumFractionDigits], or
  /// [maximumFractionDigits] are specified, the number is formatted according
  /// to locale defaults.
  ///
  /// Before using this method, ensure that [getSettings] has been called to
  /// load the plaform settings.
  ///
  /// Parameters:
  /// * [number] - The number to format.
  /// * [decimalPlaces] - Specify an exact number of decimal places to show.
  /// If this is specified, it overrides [minimumFractionDigits] and
  /// [maximumFractionDigits].
  /// * [significantDigits] - Specify the number of significant digits.
  /// * [minimumFractionDigits] - Specify minimum decimal places to show.
  /// * [maximumFractionDigits] - Specify maximum decimal places to show.
  /// * [useGrouping] - Separate into groups (e.g. thousands). Defaults to true.
  /// * [asPercentage] - Formats the number as a percentage. Defaults to false.
  String formatNumber(
    double number, {
    int? decimalPlaces,
    int? significantDigits,
    int? minimumFractionDigits,
    int? maximumFractionDigits,
    bool useGrouping = true,
    bool asPercentage = false,
  }) {
    assert(decimalPlaces == null || decimalPlaces >= 0,
        'decimalPlaces must be a non-negative integer');
    assert(significantDigits == null || significantDigits >= 0,
        'significantDigits must be a non-negative integer');
    assert(minimumFractionDigits == null || minimumFractionDigits >= 0,
        'minimumFractionDigits must be a non-negative integer');
    assert(maximumFractionDigits == null || maximumFractionDigits >= 0,
        'maximumFractionDigits must be a non-negative integer');
    assert(
      minimumFractionDigits == null ||
          maximumFractionDigits == null ||
          minimumFractionDigits <= maximumFractionDigits,
      'minimumFractionDigits must not be greater than maximumFractionDigits',
    );

    // Ensure the number symbols are configured before we attempt to use them
    _setNumberSymbols(
        locale, icuNumberFormat, decimalSeparator, groupSeparator);

    NumberFormat formatter = NumberFormat(
      icuNumberFormat + (asPercentage ? '%' : ''),
      _numberSymbolsName,
    );
    if (decimalPlaces != null) {
      formatter.minimumFractionDigits = decimalPlaces;
      formatter.maximumFractionDigits = decimalPlaces;
    } else {
      if (minimumFractionDigits != null) {
        formatter.minimumFractionDigits = minimumFractionDigits;
      }
      if (maximumFractionDigits != null) {
        formatter.maximumFractionDigits = maximumFractionDigits;
      }
    }
    if (significantDigits != null) {
      formatter.significantDigitsInUse = true;
      formatter.significantDigits = significantDigits;
    }
    if (!useGrouping) {
      formatter.turnOffGrouping();
    }

    return formatter.format(number);
  }

  /// Get the temperature units from device settings.
  ///
  /// Returns a [TemperatureUnit] enum (temperature unit options).
  ///
  /// ## iOS Implementation
  ///
  /// This plugin accesses Language & Region settings on iOS. Users can specify
  /// a Temperature preference (degrees C or degrees F) and a Measurement
  /// System preference (US, UK, or Metric). For the purposes of this plugin,
  /// the UK Measurement System is considered equivalent to Metric.
  ///
  /// Note that the Temperature preference is not always honored when running
  /// on iOS simulators; however, it is reported correctly on physical devices.
  ///
  /// ## Android Implementation
  ///
  /// Android 14 and later include a separate Temperature preference in
  /// Regional Preferences. If available, the plugin will use this setting. If
  /// not available, the plugin will fall back to the locale, where Metric
  /// countries are assumed to use Celsius and non-Metric countries are assumed
  /// to use Fahrenheit.
  static Future<TemperatureUnit> getTemperatureUnits() async {
    String temperatureUnits =
        await RegionSettingsPlatform.instance.getTemperatureUnits() ?? '';
    if (temperatureUnits
        .toUpperCase()
        .startsWith(TemperatureUnit.fahrenheit.value)) {
      return TemperatureUnit.fahrenheit;
    } else {
      return TemperatureUnit.celsius;
    }
  }

  /// Check if device is set to use metric system.
  ///
  /// Returns true if the device uses metric; false if not.
  ///
  /// ## iOS Implementation
  ///
  /// This plugin accesses Language & Region settings on iOS. Users can specify
  /// a Temperature preference (degrees C or degrees F) and a Measurement
  /// System preference (US, UK, or Metric). For the purposes of this plugin,
  /// the UK Measurement System is considered equivalent to Metric.
  ///
  /// ## Android Implementation
  ///
  /// Android 16 and later include a separate Measurement System preference in
  /// Regional preferences. If available, the plugin will use this setting. If
  /// not available, the plugin must guess the measurement system based on the
  /// device's locale. The plugin considers the following countries to be
  /// non-Metric:
  /// * American Samoa (US)
  /// * Bahamas
  /// * Belize
  /// * Cayman Islands
  /// * Guam (US)
  /// * Liberia
  /// * Marshall Islands
  /// * Micronesia
  /// * Northern Mariana Islands (US)
  /// * Palau
  /// * Turks and Caicos Islands
  /// * United States
  /// * US Minor Outlying Islands
  /// * US Virgin Islands
  ///
  /// All other countries are considered to be Metric users.
  static Future<bool> getUsesMetricSystem() async {
    bool usesMetricSystem =
        await RegionSettingsPlatform.instance.getUsesMetricSystem() ?? true;
    return Future.value(usesMetricSystem);
  }

  /// Get the first day of the week from device settings.
  ///
  /// Returns an integer in the range 1..7, where 1 is Monday and 7 is Sunday.
  /// This value corresponds to the dart:core
  /// [DateTime weekday](https://api.dart.dev/stable/3.5.3/dart-core/DateTime/weekday.html)
  /// property, and can be compared to constants such as DateTime.monday.
  ///
  /// ## iOS Implementation
  ///
  /// iOS 16 and later add a First Day of Week preference to Language & Region.
  /// iOS allows selecting any of day of the week. To surface the user's first
  /// day of week preference, the First Day of Week setting is used by this
  /// plugin, if available. On older versions of iOS that lack this setting,
  /// the plugin falls back to assuming the first day of week based on the
  /// device's locale. See **Table of First Day of Week by Country** below.
  ///
  /// ## Android Implementation
  ///
  /// Android 14 and later add a First Day of Week preference to Regional
  /// Preferences. Android allows selecting any of day of the week. To surface
  /// the user's first day of week preference, the First Day of Week setting is
  /// used by this plugin, if available. On older versions of Android that lack
  /// this setting, the plugin falls back to assuming the first day of week
  /// based on the device's locale. See **Table of First Day of Week by
  /// Country** below.
  ///
  /// ## Table of First Day of Week by Country
  ///
  /// In most countries, Monday or Sunday are considered the first day of the
  /// week, with Friday or Saturday also used in some places. The following
  /// table shows how this plugin determines which countries use which day.
  /// This list was sourced from https://github.com/unicode-org/cldr.
  ///
  /// | Monday | Friday | Saturday | Sunday |
  /// |-|-|-|-|
  /// | _All other countries_ | Maldives | American Samoa (US) | Antigua and Barbuda |
  /// | | | Afghanistan | Australia |
  /// | | | Algeria | Bahamas |
  /// | | | Bahrain | Bangladesh |
  /// | | | Djibouti | Belize |
  /// | | | Egypt | Bhutan |
  /// | | | Iran | Botswana |
  /// | | | Iraq | Brazil |
  /// | | | Jordan | Cambodia |
  /// | | | Kuwait | Canada |
  /// | | | Libya | China |
  /// | | | Oman | Colombia |
  /// | | | Qatar | Dominica |
  /// | | | Sudan | Dominican Republic |
  /// | | | Syria | El Salvador |
  /// | | | United Arab Emirates | Ethiopia |
  /// | | | | Guam (US) |
  /// | | | | Guatemala |
  /// | | | | Honduras |
  /// | | | | Hong Kong |
  /// | | | | India |
  /// | | | | Indonesia |
  /// | | | | Israel |
  /// | | | | Jamaica |
  /// | | | | Japan |
  /// | | | | Kenya |
  /// | | | | Laos |
  /// | | | | Macau |
  /// | | | | Malta |
  /// | | | | Marshall Islands |
  /// | | | | Mexico |
  /// | | | | Mozambique |
  /// | | | | Myanmar |
  /// | | | | Nepal |
  /// | | | | Nicaragua |
  /// | | | | Pakistan |
  /// | | | | Panama |
  /// | | | | Paraguay |
  /// | | | | Peru |
  /// | | | | Philippines |
  /// | | | | Portugal |
  /// | | | | Puerto Rico |
  /// | | | | Samoa |
  /// | | | | Saudi Arabia |
  /// | | | | Singapore |
  /// | | | | South Africa |
  /// | | | | South Korea |
  /// | | | | Taiwan |
  /// | | | | Thailand |
  /// | | | | Trinidad and Tobago |
  /// | | | | United States |
  /// | | | | US Minor Outlying Islands |
  /// | | | | US Virgin Islands |
  /// | | | | Venezuela |
  /// | | | | Yemen |
  /// | | | | Zimbabwe |
  static Future<int> getFirstDayOfWeek() async {
    String firstDayOfWeek =
        await RegionSettingsPlatform.instance.getFirstDayOfWeek() ?? '';
    switch (firstDayOfWeek.toUpperCase().substring(0, 2)) {
      case 'TU':
        return DateTime.tuesday;
      case 'WE':
        return DateTime.wednesday;
      case 'TH':
        return DateTime.thursday;
      case 'FR':
        return DateTime.friday;
      case 'SA':
        return DateTime.saturday;
      case 'SU':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }

  /// Get the date formats from device settings.
  ///
  /// Returns a list of date format strings corresponding to short, medium, and
  /// long date formats. The three values are the date formatting patterns used
  /// by the device's locale and/or region settings. For example, the UK
  /// English short date format is typically 'dd/MM/y', while US English uses
  /// 'MM/dd/y'. Pass the date format pattern to a function like
  /// [intl DateFormat](https://pub.dev/packages/intl) to use this in a Flutter
  /// app.
  ///
  /// ## iOS Implementation
  ///
  /// The plugin gets date and number format patterns from iOS. On older
  /// versions of iOS, the format patterns depend on the device's language
  /// setting. iOS 16 and later add Date Format and Number Format preferences
  /// to Language & Region, which allows the user to change the formats
  /// independently of the language's defaults, including the separator
  /// characters.
  ///
  /// ## Android Implementation
  ///
  /// Android date formats are based on the device's locale. However, fetching
  /// the date format pattern is only possible in API 26 (Oreo) and later. The
  /// plugin will do this on supported versions of Android. On older versions
  /// of Android, the plugin falls back to standard patterns that should be
  /// recognizable worldwide, such as 'yyyy-MM-dd' for the short date.
  static Future<List<String>> getDateFormatsList() async {
    List<String> dateFormatsList =
        await RegionSettingsPlatform.instance.getDateFormatsList() ??
            ['', '', ''];
    return Future.value(dateFormatsList);
  }

  /// Get the number formats from device settings.
  ///
  /// Returns a list of number format strings corresponding to integer and
  /// decimal number formats. The two values are the number formatting patterns
  /// used by the device's locale and/or region settings. This includes group
  /// separator characters. For example, US and UK English typically use
  /// decimal number format '#,###,###.##', while in France '# ### ###,##' is
  /// the default. Unfortunately, not all number format patterns work with
  /// [intl NumberFormat](https://pub.dev/packages/intl), so it is not
  /// recommended to pass the pattern directly to NumberFormat. Instead, parse
  /// the pattern as needed.
  ///
  /// ## iOS Implementation
  ///
  /// The plugin gets date and number format patterns from iOS. On older
  /// versions of iOS, the format patterns depend on the device's language
  /// setting. iOS 16 and later add Date Format and Number Format preferences
  /// to Language & Region, which allows the user to change the formats
  /// independently of the language's defaults, including the separator
  /// characters.
  ///
  /// ## Android Implementation
  ///
  /// Android number formats are based on the device's locale using standard
  /// Java NumberFormat methods.
  static Future<List<String>> getNumberFormatsList() async {
    List<String> numberFormatsList =
        await RegionSettingsPlatform.instance.getNumberFormatsList() ??
            ['', ''];
    return Future.value(numberFormatsList);
  }

  /// Search a string for the first instance of any non-digit character.
  ///
  /// This method is private and used internally to parse platform patterns.
  static String? _findFirstNonDigit(String text) {
    RegExp nonDigit = RegExp(_nonDigitRegex);
    Match? match = nonDigit.firstMatch(text);
    return match?.group(0);
  }

  /// Search a string for the last instance of any non-digit character.
  ///
  /// This method is private and used internally to parse platform patterns.
  static String? _findLastNonDigit(String text) {
    RegExp nonDigit = RegExp(_nonDigitRegex);
    int lastIndex = text.lastIndexOf(nonDigit);

    if (lastIndex != -1) {
      return text[lastIndex];
    } else {
      return null;
    }
  }

  /// Determine the ICU standard number format pattern from a region pattern.
  /// This is needed to convert platform number patterns into a format that can
  /// be used with [intl NumberFormat](https://pub.dev/packages/intl), which
  /// expects ICU style patterns where decimal and grouping separators are
  /// standardized.
  ///
  /// This method is private and used internally to parse platform patterns.
  static String _getIcuNumberFormat(
    String formatPattern,
    String decimalSeparator,
    String groupSeparator,
  ) {
    // Use a map to store the replacement for each separator
    final Map<String, String> replacements = {
      groupSeparator: _defaultGroupSeparator,
      decimalSeparator: _defaultDecimalSeparator,
    };

    // Create a regular expression that matches either separator character
    final RegExp separatorRegExp = RegExp(
      '(${RegExp.escape(groupSeparator)}|${RegExp.escape(decimalSeparator)})',
    );

    return formatPattern.replaceAllMapped(separatorRegExp, (match) {
      String matchedSeparator = match.group(0)!;
      // Return the corresponding replacement from the map
      return replacements[matchedSeparator]!;
    });
  }

  /// Create number formatting symbols using regional settings.
  ///
  /// This method sets up the number formatting symbols for the current locale
  /// and overrides the decimal and group separators with the regional settings.
  /// It is called during initialization to ensure that the number formatting
  /// symbols are correctly configured based on the device's locale and region
  /// settings.
  ///
  /// This method is private and used internally to manage platform patterns.
  static void _setNumberSymbols(
    String locale,
    String icuNumberFormat,
    String decimalSeparator,
    String groupSeparator,
  ) {
    NumberSymbols localeSymbols =
        numberFormatSymbols[locale] ?? numberFormatSymbols['en_US']!;
    NumberSymbols regionSymbols = NumberSymbols(
      NAME: _numberSymbolsName,
      DECIMAL_SEP: decimalSeparator, // override with regional setting
      GROUP_SEP: groupSeparator, // override with regional setting
      PERCENT: localeSymbols.PERCENT,
      ZERO_DIGIT: localeSymbols.ZERO_DIGIT,
      PLUS_SIGN: localeSymbols.PLUS_SIGN,
      MINUS_SIGN: localeSymbols.MINUS_SIGN,
      EXP_SYMBOL: localeSymbols.EXP_SYMBOL,
      PERMILL: localeSymbols.PERMILL,
      INFINITY: localeSymbols.INFINITY,
      NAN: localeSymbols.NAN,
      DECIMAL_PATTERN: icuNumberFormat, // override with regional setting
      SCIENTIFIC_PATTERN: localeSymbols.SCIENTIFIC_PATTERN,
      PERCENT_PATTERN: localeSymbols.PERCENT_PATTERN,
      CURRENCY_PATTERN: localeSymbols.CURRENCY_PATTERN,
      DEF_CURRENCY_CODE: localeSymbols.DEF_CURRENCY_CODE,
    );
    numberFormatSymbols[_numberSymbolsName] = regionSymbols;
  }

  /// Output regional settings as a formatted string.
  @override
  String toString() {
    return '''RegionSettings(
      locale: $locale,
      temperatureUnits: $temperatureUnits,
      usesMetricSystem: $usesMetricSystem,
      firstDayOfWeek: $firstDayOfWeek,
      dateFormat: $dateFormat,
      numberFormat: $numberFormat,
      icuNumberFormat: $icuNumberFormat,
      decimalSeparator: $decimalSeparator,
      groupSeparator: $groupSeparator,
    )''';
  }
}
