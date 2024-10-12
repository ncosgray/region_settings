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
import 'package:intl/intl.dart';
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
  int? _firstDayOfWeek;
  String? _dateFormatShort;
  String? _dateFormatMedium;
  String? _dateFormatLong;

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
    int firstDayOfWeek = regionSettings.firstDayOfWeek;
    String dateFormatShort = regionSettings.dateFormat.short;
    String dateFormatMedium = regionSettings.dateFormat.medium;
    String dateFormatLong = regionSettings.dateFormat.long;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _temperatureUnits = temperatureUnits;
      _usesMetricSystem = usesMetricSystem;
      _firstDayOfWeek = firstDayOfWeek;
      _dateFormatShort = dateFormatShort;
      _dateFormatMedium = dateFormatMedium;
      _dateFormatLong = dateFormatLong;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RegionSettings example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 4.0,
                  shrinkWrap: true,
                  children: [
                    const Text('temperatureUnits:'),
                    Text(
                      '$_temperatureUnits',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('usesMetricSystem:'),
                    Text(
                      '$_usesMetricSystem',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('firstDayOfWeek:'),
                    Text(
                      '$_firstDayOfWeek',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('firstDayOfWeek is Monday:'),
                    Text(
                      '${_firstDayOfWeek == DateTime.monday}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('dateFormat.short:'),
                    Text(
                      '$_dateFormatShort',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Today as dateFormat.short:'),
                    Text(
                      DateFormat(_dateFormatShort).format(DateTime.now()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('dateFormat.medium:'),
                    Text(
                      '$_dateFormatMedium',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Today as dateFormat.medium:'),
                    Text(
                      DateFormat(_dateFormatMedium).format(DateTime.now()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('dateFormat.long:'),
                    Text(
                      '$_dateFormatLong',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Today as dateFormat.long:'),
                    Text(
                      DateFormat(_dateFormatLong).format(DateTime.now()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(
                onPressed: () => loadRegionSettings(),
                child: const Text('Reload Values'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
