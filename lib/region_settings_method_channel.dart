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

  @override
  Future<bool?> usesMetricSystem() async {
    final usesMetricSystem =
        await methodChannel.invokeMethod<bool?>('usesMetricSystem');
    return usesMetricSystem;
  }

  @override
  Future<String?> getTemperatureUnits() async {
    final getTemperatureUnits =
        await methodChannel.invokeMethod<String>('getTemperatureUnits');
    return getTemperatureUnits;
  }
}
