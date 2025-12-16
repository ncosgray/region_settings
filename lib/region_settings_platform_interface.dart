/*
 *******************************************************************************
 Package:  region_settings
 Class:    region_settings_platform_interface.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.
 *******************************************************************************
*/

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'region_settings_method_channel.dart';

/// Implementation of [RegionSettingsPlatform].
abstract class RegionSettingsPlatform extends PlatformInterface {
  /// Constructs a RegionSettingsPlatform.
  RegionSettingsPlatform() : super(token: _token);

  static final Object _token = Object();

  static RegionSettingsPlatform _instance = MethodChannelRegionSettings();

  /// The default instance of [RegionSettingsPlatform] to use.
  ///
  /// Defaults to [MethodChannelRegionSettings].
  static RegionSettingsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RegionSettingsPlatform] when
  /// they register themselves.
  static set instance(RegionSettingsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns a string indicating temperature unit (C or F).
  Future<String?> getTemperatureUnits() => throw UnimplementedError(
      'getTemperatureUnits() has not been implemented.');

  /// Returns a boolean indicating if the device is set to use Metric.
  Future<bool?> getUsesMetricSystem() => throw UnimplementedError(
      'getUsesMetricSystem() has not been implemented.');

  /// Returns an integer denoting the first day of the week.
  Future<String?> getFirstDayOfWeek() =>
      throw UnimplementedError('getFirstDayOfWeek() has not been implemented.');

  /// Returns a list of date format patterns as strings.
  Future<List<String>?> getDateFormatsList() => throw UnimplementedError(
      'getDateFormatsList() has not been implemented.');

  /// Returns a list of time format patterns as strings.
  Future<List<String>?> getTimeFormatsList() => throw UnimplementedError(
      'getTimeFormatsList() has not been implemented.');

  /// Returns a list of number format patterns as strings.
  Future<List<String>?> getNumberFormatsList() => throw UnimplementedError(
      'getNumberFormatsList() has not been implemented.');
}
