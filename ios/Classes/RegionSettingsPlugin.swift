/*
 *******************************************************************************
 Package:  region_settings
 Class:    RegionSettingsPlugin.swift
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.
 *******************************************************************************
*/

import Flutter
import UIKit

public class RegionSettingsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "region_settings", binaryMessenger: registrar.messenger())
    let instance = RegionSettingsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getTemperatureUnits":
      result(getTemperatureUnits())
    case "getUsesMetricSystem":
      result(getUsesMetricSystem())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // Get the temperature units from device settings
  private func getTemperatureUnits() -> String {
    let formatter = MeasurementFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    formatter.unitStyle = .medium
    let formatted = formatter.string(from: .init(value: 0, unit: UnitTemperature.celsius))
    let symbol = String(formatted.suffix(2))
    switch (symbol) {
      case UnitTemperature.fahrenheit.symbol:
        return "F"
      default:
        return "C"
    }
  }

  // Check if device is set to use metric system
  private func getUsesMetricSystem() -> Bool {
    if #available(iOS 16, *) {
        return Locale.autoupdatingCurrent.measurementSystem != Locale.MeasurementSystem.us
    } else {
        return Locale.autoupdatingCurrent.usesMetricSystem
    }
  }
}
