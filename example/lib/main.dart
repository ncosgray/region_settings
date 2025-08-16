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
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:region_settings/region_settings.dart';

late RegionSettings regionSettings;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  regionSettings = await RegionSettings.getSettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _locale;
  TemperatureUnit? _temperatureUnits;
  bool? _usesMetricSystem;
  int? _firstDayOfWeek;
  String? _dateFormatShort;
  String? _dateFormatMedium;
  String? _dateFormatLong;
  String? _numberFormatInteger;
  String? _numberFormatDecimal;

  @override
  void initState() {
    super.initState();
    loadRegionSettings();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> loadRegionSettings() async {
    regionSettings = await RegionSettings.getSettings();
    String locale = regionSettings.locale;
    TemperatureUnit temperatureUnits = regionSettings.temperatureUnits;
    bool usesMetricSystem = regionSettings.usesMetricSystem;
    int firstDayOfWeek = regionSettings.firstDayOfWeek;
    String dateFormatShort = regionSettings.dateFormat.short;
    String dateFormatMedium = regionSettings.dateFormat.medium;
    String dateFormatLong = regionSettings.dateFormat.long;
    String numberFormatInteger = regionSettings.numberFormat.integer;
    String numberFormatDecimal = regionSettings.numberFormat.decimal;

    // Get default locale for DateFormat
    await initializeDateFormatting();
    Intl.defaultLocale = await findSystemLocale();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _locale = locale;
      _temperatureUnits = temperatureUnits;
      _usesMetricSystem = usesMetricSystem;
      _firstDayOfWeek = firstDayOfWeek;
      _dateFormatShort = dateFormatShort;
      _dateFormatMedium = dateFormatMedium;
      _dateFormatLong = dateFormatLong;
      _numberFormatInteger = numberFormatInteger;
      _numberFormatDecimal = numberFormatDecimal;
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
                  physics: const ScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 4.0,
                  shrinkWrap: true,
                  children: [
                    const Text('locale:'),
                    Text(
                      '$_locale',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                    const Text('numberFormat.integer:'),
                    Text(
                      '$_numberFormatInteger',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('formatNumber() with integer:'),
                    Text(
                      regionSettings.formatNumber(
                        1234567,
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('numberFormat.decimal:'),
                    Text(
                      '$_numberFormatDecimal',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('formatNumber() with decimal:'),
                    Text(
                      regionSettings.formatNumber(1234567.89,
                          decimalPlaces: 2, useGrouping: true),
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
