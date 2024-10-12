/*
 *******************************************************************************
 Package:  region_settings
 Class:    RegionSettingsPlugin.kt
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.
 *******************************************************************************
*/

package com.nathanatos.region_settings

import android.content.Context
import android.os.Build
import androidx.core.text.util.LocalePreferences
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.time.chrono.IsoChronology
import java.time.format.DateTimeFormatterBuilder
import java.time.format.FormatStyle
import java.util.Locale

/** RegionSettingsPlugin */
class RegionSettingsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "region_settings")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getTemperatureUnits" -> {
        result.success(getTemperatureUnits())
      }
      "getUsesMetricSystem" -> {
        result.success(getUsesMetricSystem())
      }
      "getFirstDayOfWeek" -> {
        result.success(getFirstDayOfWeek())
      }
      "getDateFormatsList" -> {
        result.success(getDateFormatsList())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  // Get the temperature units from device settings, or use locale default
  private fun getTemperatureUnits(): String {
    var temperatureUnits = "C"
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      temperatureUnits = LocalePreferences.getTemperatureUnit()
    }
    else if (!getUsesMetricSystem()) {
      temperatureUnits = "F"
    }
    return temperatureUnits
  }

  // Get the device locale
  private fun getLocale(): Locale {
    val locale: Locale = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      context.resources.configuration.locales.get(0)
    } else {
      context.resources.configuration.locale
    }
    return locale
  }

  // Check if device locale is set to a country that uses metric system
  private fun getUsesMetricSystem(): Boolean {
    val countryCode: String = getLocale().country
    var usesMetricSystem = true
    when (countryCode) {
      "AS" -> usesMetricSystem = false // American Samoa (US)
      "BS" -> usesMetricSystem = false // Bahamas
      "BZ" -> usesMetricSystem = false // Belize
      "FM" -> usesMetricSystem = false // Micronesia
      "GU" -> usesMetricSystem = false // Guam (US)
      "KY" -> usesMetricSystem = false // Cayman Islands
      "LR" -> usesMetricSystem = false // Liberia
      "MH" -> usesMetricSystem = false // Marshall Islands
      "MP" -> usesMetricSystem = false // Northern Mariana Islands (US)
      "PW" -> usesMetricSystem = false // Palau
      "TC" -> usesMetricSystem = false // Turks and Caicos Islands
      "UM" -> usesMetricSystem = false // US Minor Outlying Islands
      "US" -> usesMetricSystem = false // United States
      "VI" -> usesMetricSystem = false // US Virgin Islands
    }
    return usesMetricSystem
  }

  // Get the first day of the week from device settings
  private fun getFirstDayOfWeek(): String {
    var firstDayOfWeek = ""
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      firstDayOfWeek = LocalePreferences.getFirstDayOfWeek()
    }
    if (firstDayOfWeek == "") {
      // Use locale to determine first day of the week
      val locale: Locale = getLocale()
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        firstDayOfWeek = LocalePreferences.getFirstDayOfWeek(locale)
      }
      else {
        val countryCode: String = locale.country
        firstDayOfWeek = "MON"
        when (countryCode) {
          "MV" -> firstDayOfWeek = "FRI" // Maldives
          "AE" -> firstDayOfWeek = "SAT" // United Arab Emirates
          "AF" -> firstDayOfWeek = "SAT" // Afghanistan
          "BH" -> firstDayOfWeek = "SAT" // Bahrain
          "DJ" -> firstDayOfWeek = "SAT" // Djibouti
          "DZ" -> firstDayOfWeek = "SAT" // Algeria
          "EG" -> firstDayOfWeek = "SAT" // Egypt
          "IQ" -> firstDayOfWeek = "SAT" // Iraq
          "IR" -> firstDayOfWeek = "SAT" // Iran
          "JO" -> firstDayOfWeek = "SAT" // Jordan
          "KW" -> firstDayOfWeek = "SAT" // Kuwait
          "LY" -> firstDayOfWeek = "SAT" // Libya
          "OM" -> firstDayOfWeek = "SAT" // Oman
          "QA" -> firstDayOfWeek = "SAT" // Qatar
          "SD" -> firstDayOfWeek = "SAT" // Sudan
          "SY" -> firstDayOfWeek = "SAT" // Syria
          "AG" -> firstDayOfWeek = "SUN" // Antigua and Barbuda
          "AS" -> firstDayOfWeek = "SUN" // American Samoa (US)
          "AU" -> firstDayOfWeek = "SUN" // Australia
          "BD" -> firstDayOfWeek = "SUN" // Bangladesh
          "BR" -> firstDayOfWeek = "SUN" // Brazil
          "BS" -> firstDayOfWeek = "SUN" // Bahamas
          "BT" -> firstDayOfWeek = "SUN" // Bhutan
          "BW" -> firstDayOfWeek = "SUN" // Botswana
          "BZ" -> firstDayOfWeek = "SUN" // Belize
          "CA" -> firstDayOfWeek = "SUN" // Canada
          "CN" -> firstDayOfWeek = "SUN" // China
          "CO" -> firstDayOfWeek = "SUN" // Colombia
          "DM" -> firstDayOfWeek = "SUN" // Dominica
          "DO" -> firstDayOfWeek = "SUN" // Dominican Republic
          "ET" -> firstDayOfWeek = "SUN" // Ethiopia
          "GT" -> firstDayOfWeek = "SUN" // Guatemala
          "GU" -> firstDayOfWeek = "SUN" // Guam (US)
          "HK" -> firstDayOfWeek = "SUN" // Hong Kong
          "HN" -> firstDayOfWeek = "SUN" // Honduras
          "ID" -> firstDayOfWeek = "SUN" // Indonesia
          "IL" -> firstDayOfWeek = "SUN" // Israel
          "IN" -> firstDayOfWeek = "SUN" // India
          "JM" -> firstDayOfWeek = "SUN" // Jamaica
          "JP" -> firstDayOfWeek = "SUN" // Japan
          "KE" -> firstDayOfWeek = "SUN" // Kenya
          "KH" -> firstDayOfWeek = "SUN" // Cambodia
          "KR" -> firstDayOfWeek = "SUN" // South Korea
          "LA" -> firstDayOfWeek = "SUN" // Laos
          "MH" -> firstDayOfWeek = "SUN" // Marshall Islands
          "MM" -> firstDayOfWeek = "SUN" // Myanmar
          "MO" -> firstDayOfWeek = "SUN" // Macau
          "MT" -> firstDayOfWeek = "SUN" // Malta
          "MX" -> firstDayOfWeek = "SUN" // Mexico
          "MZ" -> firstDayOfWeek = "SUN" // Mozambique
          "NI" -> firstDayOfWeek = "SUN" // Nicaragua
          "NP" -> firstDayOfWeek = "SUN" // Nepal
          "PA" -> firstDayOfWeek = "SUN" // Panama
          "PE" -> firstDayOfWeek = "SUN" // Peru
          "PH" -> firstDayOfWeek = "SUN" // Philippines
          "PK" -> firstDayOfWeek = "SUN" // Pakistan
          "PR" -> firstDayOfWeek = "SUN" // Puerto Rico
          "PT" -> firstDayOfWeek = "SUN" // Portugal
          "PY" -> firstDayOfWeek = "SUN" // Paraguay
          "SA" -> firstDayOfWeek = "SUN" // Saudi Arabia
          "SG" -> firstDayOfWeek = "SUN" // Singapore
          "SV" -> firstDayOfWeek = "SUN" // El Salvador
          "TH" -> firstDayOfWeek = "SUN" // Thailand
          "TT" -> firstDayOfWeek = "SUN" // Trinidad and Tobago
          "TW" -> firstDayOfWeek = "SUN" // Taiwan
          "UM" -> firstDayOfWeek = "SUN" // US Minor Outlying Islands
          "US" -> firstDayOfWeek = "SUN" // United States
          "VE" -> firstDayOfWeek = "SUN" // Venezuela
          "VI" -> firstDayOfWeek = "SUN" // US Virgin Islands
          "WS" -> firstDayOfWeek = "SUN" // Samoa
          "YE" -> firstDayOfWeek = "SUN" // Yemen
          "ZA" -> firstDayOfWeek = "SUN" // South Africa
          "ZW" -> firstDayOfWeek = "SUN" // Zimbabwe
        }
      }
    }
    return firstDayOfWeek
  }

  // Get the date formats from device settings, or use generic default
  private fun getDateFormatsList(): MutableList<String> {
    val dateFormatsList = mutableListOf("yyyy-MM-dd", "dd MMM yyyy", "dd MMMM yyyy")
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      dateFormatsList[0] = DateTimeFormatterBuilder.getLocalizedDateTimePattern(
        FormatStyle.SHORT,
        null,
        IsoChronology.INSTANCE,
        getLocale())
      dateFormatsList[1] = DateTimeFormatterBuilder.getLocalizedDateTimePattern(
        FormatStyle.MEDIUM,
        null,
        IsoChronology.INSTANCE,
        getLocale())
      dateFormatsList[2] = DateTimeFormatterBuilder.getLocalizedDateTimePattern(
        FormatStyle.LONG,
        null,
        IsoChronology.INSTANCE,
        getLocale())
    }
    return dateFormatsList
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
