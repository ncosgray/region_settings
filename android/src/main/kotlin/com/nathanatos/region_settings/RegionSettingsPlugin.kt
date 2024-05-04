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
      "usesMetricSystem" -> {
        result.success(usesMetricSystem())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  // Get the temperature units from device settings, or use locale default
  private fun getTemperatureUnits(): String {
    var getTemperatureUnits = "C"
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      getTemperatureUnits = LocalePreferences.getTemperatureUnit()
    }
    else if (!usesMetricSystem()) {
      getTemperatureUnits = "F"
    }
    return getTemperatureUnits
  }

  // Check if device locale is set to a country that uses metric system
  private fun usesMetricSystem(): Boolean {
    val locale: Locale = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      context.resources.configuration.locales.get(0)
    } else {
      context.resources.configuration.locale
    }

    val countryCode: String = locale.country
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

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
