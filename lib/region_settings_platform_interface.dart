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

  Future<String?> getTemperatureUnits() => throw UnimplementedError(
      'getTemperatureUnits() has not been implemented.');

  Future<bool?> getUsesMetricSystem() => throw UnimplementedError(
      'getUsesMetricSystem() has not been implemented.');
}
