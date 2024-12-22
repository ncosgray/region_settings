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

// Temperature unit options enum
enum TemperatureUnit {
  celsius('C'),
  fahrenheit('F');

  final String value;

  const TemperatureUnit(this.value);

  @override
  String toString() {
    return 'TemperatureUnit.$name';
  }
}

// Date format options class
class RegionDateFormats {
  RegionDateFormats({
    required this.short,
    required this.medium,
    required this.long,
  });

  final String short;
  final String medium;
  final String long;

  @override
  String toString() {
    return '''RegionDateFormats(
      short: '$short',
      medium: '$medium',
      long: '$long',
    )''';
  }
}

// Number format options class
class RegionNumberFormats {
  RegionNumberFormats({
    required this.integer,
    required this.decimal,
  });

  final String integer;
  final String decimal;

  @override
  String toString() {
    return '''RegionNumberFormats(
      integer: '$integer',
      decimal: '$decimal',
    )''';
  }
}

class RegionSettings {
  RegionSettings({
    required this.temperatureUnits,
    required this.usesMetricSystem,
    required this.firstDayOfWeek,
    required this.dateFormat,
    required this.numberFormat,
  });

  final TemperatureUnit temperatureUnits;
  final bool usesMetricSystem;
  final int firstDayOfWeek;
  final RegionDateFormats dateFormat;
  final RegionNumberFormats numberFormat;

  // Load all available region settings
  static Future<RegionSettings> getSettings() async {
    TemperatureUnit temperatureUnits = await getTemperatureUnits();
    bool usesMetricSystem = await getUsesMetricSystem();
    int firstDayOfWeek = await getFirstDayOfWeek();
    List<String> dateFormatsList = await getDateFormatsList();
    List<String> numberFormatsList = await getNumberFormatsList();

    return RegionSettings(
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
    );
  }

  // Get the temperature units from device settings
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

  // Check if device is set to use metric system
  static Future<bool> getUsesMetricSystem() async {
    bool usesMetricSystem =
        await RegionSettingsPlatform.instance.getUsesMetricSystem() ?? true;
    return Future.value(usesMetricSystem);
  }

  // Get the first day of the week from device settings
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

  // Get the date formats from device settings
  static Future<List<String>> getDateFormatsList() async {
    List<String> dateFormatsList =
        await RegionSettingsPlatform.instance.getDateFormatsList() ??
            ['', '', ''];
    return Future.value(dateFormatsList);
  }

  // Get the number formats from device settings
  static Future<List<String>> getNumberFormatsList() async {
    List<String> numberFormatsList =
        await RegionSettingsPlatform.instance.getNumberFormatsList() ??
            ['', '', ''];
    return Future.value(numberFormatsList);
  }

  // Output settings as a string
  @override
  String toString() {
    return '''RegionSettings(
      temperatureUnits: $temperatureUnits,
      usesMetricSystem: $usesMetricSystem,
      firstDayOfWeek: $firstDayOfWeek,
      dateFormat: $dateFormat,
      numberFormat: $numberFormat,
    )''';
  }
}
