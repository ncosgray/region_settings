/*
 *******************************************************************************
 Package:  region_settings
 Class:    region_settings_method_channel.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.
 *******************************************************************************
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'region_settings_platform_interface.dart';

/// An implementation of [RegionSettingsPlatform] that uses method channels.
class MethodChannelRegionSettings extends RegionSettingsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('region_settings');

  /// Returns a string indicating temperature unit (C or F).
  @override
  Future<String?> getTemperatureUnits() async {
    final temperatureUnits =
        await methodChannel.invokeMethod<String>('getTemperatureUnits');
    return temperatureUnits;
  }

  /// Returns a boolean indicating if the device is set to use Metric.
  @override
  Future<bool?> getUsesMetricSystem() async {
    final usesMetricSystem =
        await methodChannel.invokeMethod<bool>('getUsesMetricSystem');
    return usesMetricSystem;
  }

  /// Returns an integer denoting the first day of the week.
  @override
  Future<String?> getFirstDayOfWeek() async {
    final firstDayOfWeek =
        await methodChannel.invokeMethod<String>('getFirstDayOfWeek');
    return firstDayOfWeek;
  }

  /// Returns a list of date format patterns as strings.
  @override
  Future<List<String>?> getDateFormatsList() async {
    final dateFormatsList =
        await methodChannel.invokeListMethod<String>('getDateFormatsList');
    return dateFormatsList;
  }

  /// Returns a list of number format patterns as strings.
  @override
  Future<List<String>?> getNumberFormatsList() async {
    final numberFormatsList =
        await methodChannel.invokeListMethod<String>('getNumberFormatsList');
    return numberFormatsList;
  }
}
