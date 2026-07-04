/*
 *******************************************************************************
 Package:  region_settings
 Class:    region_settings_test.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.
 *******************************************************************************
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:region_settings/region_settings.dart';
import 'package:region_settings/region_settings_platform_interface.dart';

/// A mock platform that simulates the values returned by a device's native
/// implementation, configurable to represent devices in different regions.
class MockRegionSettingsPlatform extends RegionSettingsPlatform
    with MockPlatformInterfaceMixin {
  MockRegionSettingsPlatform({
    this.temperatureUnits,
    this.usesMetricSystem,
    this.firstDayOfWeek,
    this.dateFormatsList,
    this.timeFormatsList,
    this.numberFormatsList,
  });

  final String? temperatureUnits;
  final bool? usesMetricSystem;
  final String? firstDayOfWeek;
  final List<String>? dateFormatsList;
  final List<String>? timeFormatsList;
  final List<String>? numberFormatsList;

  @override
  Future<String?> getTemperatureUnits() async => temperatureUnits;

  @override
  Future<bool?> getUsesMetricSystem() async => usesMetricSystem;

  @override
  Future<String?> getFirstDayOfWeek() async => firstDayOfWeek;

  @override
  Future<List<String>?> getDateFormatsList() async => dateFormatsList;

  @override
  Future<List<String>?> getTimeFormatsList() async => timeFormatsList;

  @override
  Future<List<String>?> getNumberFormatsList() async => numberFormatsList;
}

/// Simulates a device set to English (United States).
MockRegionSettingsPlatform englishUSDevice() => MockRegionSettingsPlatform(
      temperatureUnits: 'F',
      usesMetricSystem: false,
      firstDayOfWeek: 'Sunday',
      dateFormatsList: ['M/d/yy', 'MMM d, y', 'MMMM d, y'],
      timeFormatsList: ['h:mm a', 'h:mm:ss a', 'h:mm:ss a z'],
      numberFormatsList: ['#,###,###', '#,###,###.##'],
    );

/// Simulates a device set to French (France).
MockRegionSettingsPlatform frenchDevice() => MockRegionSettingsPlatform(
      temperatureUnits: 'C',
      usesMetricSystem: true,
      firstDayOfWeek: 'Monday',
      dateFormatsList: ['dd/MM/y', 'd MMM y', 'd MMMM y'],
      timeFormatsList: ['HH:mm', 'HH:mm:ss', 'HH:mm:ss z'],
      numberFormatsList: ['# ### ###', '# ### ###,##'],
    );

/// Simulates a device set to German (Germany).
MockRegionSettingsPlatform germanDevice() => MockRegionSettingsPlatform(
      temperatureUnits: 'C',
      usesMetricSystem: true,
      firstDayOfWeek: 'Monday',
      dateFormatsList: ['dd.MM.yy', 'dd.MM.y', 'd. MMMM y'],
      timeFormatsList: ['HH:mm', 'HH:mm:ss', 'HH:mm:ss z'],
      numberFormatsList: ['#.###.###', '#.###.###,##'],
    );

/// Builds a RegionSettings instance directly, bypassing the platform, so that
/// formatting behavior can be tested deterministically for a known locale.
RegionSettings buildRegionSettings({
  required String locale,
  required List<String> dateFormats,
  required List<String> timeFormats,
  required String decimalSeparator,
  required String groupSeparator,
}) {
  return RegionSettings(
    locale: locale,
    temperatureUnits: TemperatureUnit.celsius,
    usesMetricSystem: true,
    firstDayOfWeek: DateTime.monday,
    dateFormat: RegionDateFormats(
      short: dateFormats[0],
      medium: dateFormats[1],
      long: dateFormats[2],
    ),
    timeFormat: RegionTimeFormats(
      short: timeFormats[0],
      medium: timeFormats[1],
      long: timeFormats[2],
    ),
    numberFormat: RegionNumberFormats(
      integer: '#,###,###',
      decimal: '#,###,###.##',
    ),
    icuNumberFormat: '#,###,###.##',
    decimalSeparator: decimalSeparator,
    groupSeparator: groupSeparator,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('getTemperatureUnits', () {
    test('parses Fahrenheit', () async {
      RegionSettingsPlatform.instance =
          MockRegionSettingsPlatform(temperatureUnits: 'F');
      expect(await RegionSettings.getTemperatureUnits(),
          TemperatureUnit.fahrenheit);
    });

    test('is case-insensitive', () async {
      RegionSettingsPlatform.instance =
          MockRegionSettingsPlatform(temperatureUnits: 'f');
      expect(await RegionSettings.getTemperatureUnits(),
          TemperatureUnit.fahrenheit);
    });

    test('parses Celsius', () async {
      RegionSettingsPlatform.instance =
          MockRegionSettingsPlatform(temperatureUnits: 'C');
      expect(
          await RegionSettings.getTemperatureUnits(), TemperatureUnit.celsius);
    });

    test('defaults to Celsius when platform returns nothing', () async {
      RegionSettingsPlatform.instance = MockRegionSettingsPlatform();
      expect(
          await RegionSettings.getTemperatureUnits(), TemperatureUnit.celsius);
    });
  });

  group('getUsesMetricSystem', () {
    test('reports non-Metric devices', () async {
      RegionSettingsPlatform.instance =
          MockRegionSettingsPlatform(usesMetricSystem: false);
      expect(await RegionSettings.getUsesMetricSystem(), false);
    });

    test('reports Metric devices', () async {
      RegionSettingsPlatform.instance =
          MockRegionSettingsPlatform(usesMetricSystem: true);
      expect(await RegionSettings.getUsesMetricSystem(), true);
    });

    test('defaults to Metric when platform returns nothing', () async {
      RegionSettingsPlatform.instance = MockRegionSettingsPlatform();
      expect(await RegionSettings.getUsesMetricSystem(), true);
    });
  });

  group('getFirstDayOfWeek', () {
    Future<int> firstDayOfWeekFor(String? platformValue) async {
      RegionSettingsPlatform.instance =
          MockRegionSettingsPlatform(firstDayOfWeek: platformValue);
      return RegionSettings.getFirstDayOfWeek();
    }

    test('parses each day of the week', () async {
      expect(await firstDayOfWeekFor('Monday'), DateTime.monday);
      expect(await firstDayOfWeekFor('Tuesday'), DateTime.tuesday);
      expect(await firstDayOfWeekFor('Wednesday'), DateTime.wednesday);
      expect(await firstDayOfWeekFor('Thursday'), DateTime.thursday);
      expect(await firstDayOfWeekFor('Friday'), DateTime.friday);
      expect(await firstDayOfWeekFor('Saturday'), DateTime.saturday);
      expect(await firstDayOfWeekFor('Sunday'), DateTime.sunday);
    });

    test('is case-insensitive and accepts abbreviations', () async {
      expect(await firstDayOfWeekFor('SUNDAY'), DateTime.sunday);
      expect(await firstDayOfWeekFor('sun'), DateTime.sunday);
      expect(await firstDayOfWeekFor('fr'), DateTime.friday);
    });

    test('defaults to Monday for missing or unrecognized values', () async {
      expect(await firstDayOfWeekFor(null), DateTime.monday);
      expect(await firstDayOfWeekFor(''), DateTime.monday);
      expect(await firstDayOfWeekFor('X'), DateTime.monday);
      expect(await firstDayOfWeekFor('someday'), DateTime.monday);
    });
  });

  group('format lists', () {
    test('date and time formats default to empty patterns', () async {
      RegionSettingsPlatform.instance = MockRegionSettingsPlatform();
      expect(await RegionSettings.getDateFormatsList(), ['', '', '']);
      expect(await RegionSettings.getTimeFormatsList(), ['', '', '']);
      expect(await RegionSettings.getNumberFormatsList(), ['', '']);
    });

    test('format lists pass through platform values', () async {
      RegionSettingsPlatform.instance = englishUSDevice();
      expect(await RegionSettings.getDateFormatsList(),
          ['M/d/yy', 'MMM d, y', 'MMMM d, y']);
      expect(await RegionSettings.getTimeFormatsList(),
          ['h:mm a', 'h:mm:ss a', 'h:mm:ss a z']);
      expect(await RegionSettings.getNumberFormatsList(),
          ['#,###,###', '#,###,###.##']);
    });
  });

  group('getSettings', () {
    test('loads settings for an English (US) device', () async {
      RegionSettingsPlatform.instance = englishUSDevice();
      RegionSettings settings = await RegionSettings.getSettings();

      expect(settings.locale, isNotEmpty);
      expect(settings.temperatureUnits, TemperatureUnit.fahrenheit);
      expect(settings.usesMetricSystem, false);
      expect(settings.firstDayOfWeek, DateTime.sunday);
      expect(settings.dateFormat.short, 'M/d/yy');
      expect(settings.dateFormat.medium, 'MMM d, y');
      expect(settings.dateFormat.long, 'MMMM d, y');
      expect(settings.timeFormat.short, 'h:mm a');
      expect(settings.timeFormat.medium, 'h:mm:ss a');
      expect(settings.timeFormat.long, 'h:mm:ss a z');
      expect(settings.numberFormat.integer, '#,###,###');
      expect(settings.numberFormat.decimal, '#,###,###.##');
      expect(settings.decimalSeparator, '.');
      expect(settings.groupSeparator, ',');
      expect(settings.icuNumberFormat, '#,###,###.##');
    });

    test('loads settings for a French device', () async {
      RegionSettingsPlatform.instance = frenchDevice();
      RegionSettings settings = await RegionSettings.getSettings();

      expect(settings.temperatureUnits, TemperatureUnit.celsius);
      expect(settings.usesMetricSystem, true);
      expect(settings.firstDayOfWeek, DateTime.monday);
      expect(settings.dateFormat.short, 'dd/MM/y');
      expect(settings.decimalSeparator, ',');
      expect(settings.groupSeparator, ' ');
      // The ICU pattern is normalized to standard separators
      expect(settings.icuNumberFormat, '#,###,###.##');
    });

    test('loads settings for a German device', () async {
      RegionSettingsPlatform.instance = germanDevice();
      RegionSettings settings = await RegionSettings.getSettings();

      expect(settings.decimalSeparator, ',');
      expect(settings.groupSeparator, '.');
      expect(settings.icuNumberFormat, '#,###,###.##');
    });

    test('handles narrow no-break space group separators', () async {
      // Newer CLDR versions use U+202F as the French group separator
      RegionSettingsPlatform.instance = MockRegionSettingsPlatform(
        numberFormatsList: ['#\u202F###\u202F###', '#\u202F###\u202F###,##'],
      );
      RegionSettings settings = await RegionSettings.getSettings();

      expect(settings.groupSeparator, '\u202F');
      expect(settings.decimalSeparator, ',');
      expect(settings.icuNumberFormat, '#,###,###.##');
    });

    test('falls back to defaults when platform returns nothing', () async {
      RegionSettingsPlatform.instance = MockRegionSettingsPlatform();
      RegionSettings settings = await RegionSettings.getSettings();

      expect(settings.temperatureUnits, TemperatureUnit.celsius);
      expect(settings.usesMetricSystem, true);
      expect(settings.firstDayOfWeek, DateTime.monday);
      expect(settings.decimalSeparator, '.');
      expect(settings.groupSeparator, ',');
    });

    test('pattern() returns the format for each style', () async {
      RegionSettingsPlatform.instance = englishUSDevice();
      RegionSettings settings = await RegionSettings.getSettings();

      expect(settings.dateFormat.pattern(DateStyle.short), 'M/d/yy');
      expect(settings.dateFormat.pattern(DateStyle.medium), 'MMM d, y');
      expect(settings.dateFormat.pattern(DateStyle.long), 'MMMM d, y');
      expect(settings.timeFormat.pattern(TimeStyle.short), 'h:mm a');
      expect(settings.timeFormat.pattern(TimeStyle.medium), 'h:mm:ss a');
      expect(settings.timeFormat.pattern(TimeStyle.long), 'h:mm:ss a z');
    });
  });

  group('formatDate and formatTime', () {
    final RegionSettings enUS = buildRegionSettings(
      locale: 'en_US',
      dateFormats: ['M/d/yy', 'MMM d, y', 'MMMM d, y'],
      timeFormats: ['h:mm a', 'h:mm:ss a', 'h:mm:ss a z'],
      decimalSeparator: '.',
      groupSeparator: ',',
    );
    final RegionSettings frFR = buildRegionSettings(
      locale: 'fr_FR',
      dateFormats: ['dd/MM/y', 'd MMM y', 'd MMMM y'],
      timeFormats: ['HH:mm', 'HH:mm:ss', 'HH:mm:ss z'],
      decimalSeparator: ',',
      groupSeparator: ' ',
    );
    final RegionSettings deDE = buildRegionSettings(
      locale: 'de_DE',
      dateFormats: ['dd.MM.yy', 'dd.MM.y', 'd. MMMM y'],
      timeFormats: ['HH:mm', 'HH:mm:ss', 'HH:mm:ss z'],
      decimalSeparator: ',',
      groupSeparator: '.',
    );
    final DateTime testDateTime = DateTime(2024, 1, 31, 14, 30, 45);

    setUpAll(() async {
      await initializeDateFormatting();
    });

    test('formats dates for English (US)', () {
      expect(
          enUS.formatDate(testDateTime, dateStyle: DateStyle.short), '1/31/24');
      expect(enUS.formatDate(testDateTime), 'Jan 31, 2024');
      expect(enUS.formatDate(testDateTime, dateStyle: DateStyle.long),
          'January 31, 2024');
    });

    test('formats dates for French', () {
      expect(frFR.formatDate(testDateTime, dateStyle: DateStyle.short),
          '31/01/2024');
      expect(frFR.formatDate(testDateTime), '31 janv. 2024');
      expect(frFR.formatDate(testDateTime, dateStyle: DateStyle.long),
          '31 janvier 2024');
    });

    test('formats dates for German', () {
      expect(deDE.formatDate(testDateTime, dateStyle: DateStyle.short),
          '31.01.24');
      expect(deDE.formatDate(testDateTime), '31.01.2024');
      expect(deDE.formatDate(testDateTime, dateStyle: DateStyle.long),
          '31. Januar 2024');
    });

    test('formats times for English (US)', () {
      expect(enUS.formatTime(testDateTime), '2:30 PM');
      expect(enUS.formatTime(testDateTime, timeStyle: TimeStyle.medium),
          '2:30:45 PM');
    });

    test('formats times for French and German', () {
      expect(frFR.formatTime(testDateTime), '14:30');
      expect(frFR.formatTime(testDateTime, timeStyle: TimeStyle.medium),
          '14:30:45');
      expect(deDE.formatTime(testDateTime), '14:30');
    });

    test('formatDate honors forceLocale', () {
      expect(enUS.formatDate(testDateTime, forceLocale: 'fr'), '31 janv. 2024');
      expect(enUS.formatDate(testDateTime, forceLocale: 'de'), '31. Jan. 2024');
      expect(
          frFR.formatDate(testDateTime,
              dateStyle: DateStyle.long, forceLocale: 'en_US'),
          'January 31, 2024');
    });

    test('formatTime honors forceLocale', () {
      // CLDR en_US uses a narrow no-break space before the AM/PM marker
      expect(
          frFR.formatTime(testDateTime, forceLocale: 'en_US'), '2:30\u202FPM');
      expect(enUS.formatTime(testDateTime, forceLocale: 'fr'), '14:30');
    });

    test('formatDate ignores forceLocale for unknown locales', () {
      // An unrecognized locale falls back to the device settings
      expect(enUS.formatDate(testDateTime, forceLocale: 'not_a_locale'),
          'Jan 31, 2024');
    });
  });

  group('formatNumber', () {
    final RegionSettings enUS = buildRegionSettings(
      locale: 'en_US',
      dateFormats: ['M/d/yy', 'MMM d, y', 'MMMM d, y'],
      timeFormats: ['h:mm a', 'h:mm:ss a', 'h:mm:ss a z'],
      decimalSeparator: '.',
      groupSeparator: ',',
    );
    final RegionSettings frFR = buildRegionSettings(
      locale: 'fr_FR',
      dateFormats: ['dd/MM/y', 'd MMM y', 'd MMMM y'],
      timeFormats: ['HH:mm', 'HH:mm:ss', 'HH:mm:ss z'],
      decimalSeparator: ',',
      groupSeparator: ' ',
    );
    final RegionSettings deDE = buildRegionSettings(
      locale: 'de_DE',
      dateFormats: ['dd.MM.yy', 'dd.MM.y', 'd. MMMM y'],
      timeFormats: ['HH:mm', 'HH:mm:ss', 'HH:mm:ss z'],
      decimalSeparator: ',',
      groupSeparator: '.',
    );

    test('formats numbers with regional separators', () {
      expect(enUS.formatNumber(1234567.891), '1,234,567.89');
      expect(frFR.formatNumber(1234567.891), '1 234 567,89');
      expect(deDE.formatNumber(1234567.891), '1.234.567,89');
    });

    test('honors decimalPlaces', () {
      expect(enUS.formatNumber(1234.5, decimalPlaces: 2), '1,234.50');
      expect(enUS.formatNumber(1234.5678, decimalPlaces: 2), '1,234.57');
      expect(frFR.formatNumber(1234.5, decimalPlaces: 3), '1 234,500');
      expect(enUS.formatNumber(1234.5678, decimalPlaces: 0), '1,235');
    });

    test('honors minimum/maximumFractionDigits', () {
      expect(enUS.formatNumber(1234.5, minimumFractionDigits: 3), '1,234.500');
      expect(enUS.formatNumber(1234.5678, maximumFractionDigits: 1), '1,234.6');
    });

    test('honors useGrouping', () {
      expect(enUS.formatNumber(1234567.891, useGrouping: false), '1234567.89');
      expect(frFR.formatNumber(1234567.891, useGrouping: false), '1234567,89');
    });

    test('honors displayTrailingZeros', () {
      expect(
          enUS.formatNumber(1234.5,
              decimalPlaces: 2, displayTrailingZeros: false),
          '1,234.5');
      expect(
          enUS.formatNumber(1234.0,
              decimalPlaces: 2, displayTrailingZeros: false),
          '1,234');
    });

    test('formats percentages', () {
      expect(enUS.formatNumber(0.5, asPercentage: true), '50%');
      expect(enUS.formatNumber(0.1234, asPercentage: true), '12.34%');
    });

    test('honors forceLocale', () {
      expect(enUS.formatNumber(1234567.891, forceLocale: 'de'), '1.234.567,89');
      expect(
          deDE.formatNumber(1234567.891, forceLocale: 'en_US'), '1,234,567.89');
    });

    test('ignores forceLocale for unknown locales', () {
      expect(enUS.formatNumber(1234567.891, forceLocale: 'not_a_locale'),
          '1,234,567.89');
    });

    test('formats numbers for non-CLDR locales', () {
      // A locale unknown to intl falls back to overridden separators
      final RegionSettings nonCldr = buildRegionSettings(
        locale: 'xx_XX',
        dateFormats: ['M/d/yy', 'MMM d, y', 'MMMM d, y'],
        timeFormats: ['h:mm a', 'h:mm:ss a', 'h:mm:ss a z'],
        decimalSeparator: ',',
        groupSeparator: '.',
      );
      expect(nonCldr.formatNumber(1234567.891), '1.234.567,89');
    });

    test('formats numbers with narrow no-break space separators', () {
      final RegionSettings narrowNbsp = buildRegionSettings(
        locale: 'fr_FR',
        dateFormats: ['dd/MM/y', 'd MMM y', 'd MMMM y'],
        timeFormats: ['HH:mm', 'HH:mm:ss', 'HH:mm:ss z'],
        decimalSeparator: ',',
        groupSeparator: '\u202F',
      );
      expect(narrowNbsp.formatNumber(1234567.891), '1\u202F234\u202F567,89');
    });
  });
}
