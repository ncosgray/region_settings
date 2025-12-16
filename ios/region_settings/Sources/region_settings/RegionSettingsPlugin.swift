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
    switch (call.method) {
      case "getTemperatureUnits":
        result(getTemperatureUnits())
      case "getUsesMetricSystem":
        result(getUsesMetricSystem())
      case "getFirstDayOfWeek":
        result(getFirstDayOfWeek())
      case "getDateFormatsList":
        result(getDateFormatsList())
      case "getTimeFormatsList":
        result(getTimeFormatsList())
      case "getNumberFormatsList":
        result(getNumberFormatsList())
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

  // Get the date formats from device settings
  private func getDateFormatsList() -> [String] {
    var dateFormatsList: [String] = []
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = DateFormatter.Style.short
    dateFormatsList.append(formatter.dateFormat)
    formatter.dateStyle = DateFormatter.Style.medium
    dateFormatsList.append(formatter.dateFormat)
    formatter.dateStyle = DateFormatter.Style.long
    dateFormatsList.append(formatter.dateFormat)
    return dateFormatsList
  }

  // Get the time formats from device settings
  private func getTimeFormatsList() -> [String] {
    var timeFormatsList: [String] = []
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = DateFormatter.Style.short
    timeFormatsList.append(formatter.dateFormat)
    formatter.timeStyle = DateFormatter.Style.medium
    timeFormatsList.append(formatter.dateFormat)
    formatter.timeStyle = DateFormatter.Style.long
    timeFormatsList.append(formatter.dateFormat)
    return timeFormatsList
  }

  // Convert 1s to #s for format pattern
  private func convertNumberToFormat(str: String?) -> String {
    return (str ?? "1").replacingOccurrences(of: "1", with: "#")
  }

  // Get the number formats from device settings
  private func getNumberFormatsList() -> [String] {
    let testNumber = NSNumber(value: 1111111.11)
    var numberFormatsList: [String] = []
    let formatter = NumberFormatter()
    formatter.locale = Locale.autoupdatingCurrent
    formatter.numberStyle  = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    numberFormatsList.append(convertNumberToFormat(str: formatter.string(from: testNumber)))
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    numberFormatsList.append(convertNumberToFormat(str: formatter.string(from: testNumber)))
    return numberFormatsList
  }
}
