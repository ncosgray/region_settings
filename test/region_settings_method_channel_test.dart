/*
 *******************************************************************************
 Package:  region_settings
 Class:    region_settings_method_channel_test.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.
 *******************************************************************************
*/

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:region_settings/region_settings_method_channel.dart';
import 'package:region_settings/region_settings_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelRegionSettings platform = MethodChannelRegionSettings();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel,
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getTemperatureUnits':
          return 'F';
        case 'getUsesMetricSystem':
          return false;
        case 'getFirstDayOfWeek':
          return 'Sunday';
        case 'getDateFormatsList':
          return ['M/d/yy', 'MMM d, y', 'MMMM d, y'];
        case 'getTimeFormatsList':
          return ['h:mm a', 'h:mm:ss a', 'h:mm:ss a z'];
        case 'getNumberFormatsList':
          return ['#,###,###', '#,###,###.##'];
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
  });

  test('MethodChannelRegionSettings is the default platform instance', () {
    expect(RegionSettingsPlatform.instance, isA<MethodChannelRegionSettings>());
  });

  test('getTemperatureUnits invokes the method channel', () async {
    expect(await platform.getTemperatureUnits(), 'F');
  });

  test('getUsesMetricSystem invokes the method channel', () async {
    expect(await platform.getUsesMetricSystem(), false);
  });

  test('getFirstDayOfWeek invokes the method channel', () async {
    expect(await platform.getFirstDayOfWeek(), 'Sunday');
  });

  test('getDateFormatsList invokes the method channel', () async {
    expect(await platform.getDateFormatsList(),
        ['M/d/yy', 'MMM d, y', 'MMMM d, y']);
  });

  test('getTimeFormatsList invokes the method channel', () async {
    expect(await platform.getTimeFormatsList(),
        ['h:mm a', 'h:mm:ss a', 'h:mm:ss a z']);
  });

  test('getNumberFormatsList invokes the method channel', () async {
    expect(
        await platform.getNumberFormatsList(), ['#,###,###', '#,###,###.##']);
  });
}
