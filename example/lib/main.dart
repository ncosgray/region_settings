/*
 *******************************************************************************
 Package:  region_settings_example
 Class:    main.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.
 *******************************************************************************
*/

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:region_settings/region_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TemperatureUnit? _temperatureUnits;
  bool? _usesMetricSystem;

  @override
  void initState() {
    super.initState();
    loadRegionSettings();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> loadRegionSettings() async {
    final RegionSettings regionSettings = await RegionSettings.getSettings();
    TemperatureUnit temperatureUnits = regionSettings.temperatureUnits;
    bool usesMetricSystem = regionSettings.usesMetricSystem;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _temperatureUnits = temperatureUnits;
      _usesMetricSystem = usesMetricSystem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RegionSettings example app'),
        ),
        body: Center(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('temperatureUnits:'),
                Text(
                  '$_temperatureUnits',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('usesMetricSystem:'),
                Text(
                  '$_usesMetricSystem',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            FilledButton.tonal(
              onPressed: () => loadRegionSettings(),
              child: const Text('Reload Values'),
            )
          ]),
        ),
      ),
    );
  }
}
