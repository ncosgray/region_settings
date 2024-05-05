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
}

class RegionSettings {
  RegionSettings({
    required this.temperatureUnits,
    required this.usesMetricSystem,
  });

  final TemperatureUnit temperatureUnits;
  final bool usesMetricSystem;

  // Load all available region settings
  static Future<RegionSettings> getSettings() async {
    TemperatureUnit temperatureUnits = await getTemperatureUnits();
    bool usesMetricSystem = await getUsesMetricSystem();

    return RegionSettings(
      temperatureUnits: temperatureUnits,
      usesMetricSystem: usesMetricSystem,
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

  // Output settings as a string
  @override
  String toString() {
    return '''RegionSettings(
      temperatureUnits: $temperatureUnits,
      usesMetricSystem: $usesMetricSystem
    )''';
  }
}
