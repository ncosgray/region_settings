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
  // Get the temperature units from device settings
  Future<TemperatureUnit> getTemperatureUnits() async {
    String getTemperatureUnits =
        await RegionSettingsPlatform.instance.getTemperatureUnits() ?? '';
    if (getTemperatureUnits
        .toUpperCase()
        .startsWith(TemperatureUnit.fahrenheit.value)) {
      return TemperatureUnit.fahrenheit;
    } else {
      return TemperatureUnit.celsius;
    }
  }

  // Check if device is set to use metric system
  Future<bool> usesMetricSystem() async {
    bool usesMetricSystem =
        await RegionSettingsPlatform.instance.usesMetricSystem() ?? true;
    return Future.value(usesMetricSystem);
  }
}
