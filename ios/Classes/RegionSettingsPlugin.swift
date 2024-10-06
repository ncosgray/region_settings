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
    case "getFirstDayOfWeek":
      result(getFirstDayOfWeek())
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

  // Get the first day of the week from device settings
  private func getFirstDayOfWeek() -> String {
    if #available(iOS 16, *) {
      return Locale.autoupdatingCurrent.firstDayOfWeek.rawValue;
    }
    else {
      // Use locale to determine first day of the week
      switch (Locale.autoupdatingCurrent.regionCode) {
        case "MV": // Maldives
          return "FRI"
        case "AE", // United Arab Emirates
             "AF", // Afghanistan
             "BH", // Bahrain
             "DJ", // Djibouti
             "DZ", // Algeria
             "EG", // Egypt
             "IQ", // Iraq
             "IR", // Iran
             "JO", // Jordan
             "KW", // Kuwait
             "LY", // Libya
             "OM", // Oman
             "QA", // Qatar
             "SD", // Sudan
             "SY": // Syria
          return "SAT"
        case "AG", // Antigua and Barbuda
             "AS", // American Samoa (US)
             "AU", // Australia
             "BD", // Bangladesh
             "BR", // Brazil
             "BS", // Bahamas
             "BT", // Bhutan
             "BW", // Botswana
             "BZ", // Belize
             "CA", // Canada
             "CN", // China
             "CO", // Colombia
             "DM", // Dominica
             "DO", // Dominican Republic
             "ET", // Ethiopia
             "GT", // Guatemala
             "GU", // Guam (US)
             "HK", // Hong Kong
             "HN", // Honduras
             "ID", // Indonesia
             "IL", // Israel
             "IN", // India
             "JM", // Jamaica
             "JP", // Japan
             "KE", // Kenya
             "KH", // Cambodia
             "KR", // South Korea
             "LA", // Laos
             "MH", // Marshall Islands
             "MM", // Myanmar
             "MO", // Macau
             "MT", // Malta
             "MX", // Mexico
             "MZ", // Mozambique
             "NI", // Nicaragua
             "NP", // Nepal
             "PA", // Panama
             "PE", // Peru
             "PH", // Philippines
             "PK", // Pakistan
             "PR", // Puerto Rico
             "PT", // Portugal
             "PY", // Paraguay
             "SA", // Saudi Arabia
             "SG", // Singapore
             "SV", // El Salvador
             "TH", // Thailand
             "TT", // Trinidad and Tobago
             "TW", // Taiwan
             "UM", // US Minor Outlying Islands
             "US", // United States
             "VE", // Venezuela
             "VI", // US Virgin Islands
             "WS", // Samoa
             "YE", // Yemen
             "ZA", // South Africa
             "ZW": // Zimbabwe
          return "SUN"
        default:
          return "MON"
      }
    }
  }
}
