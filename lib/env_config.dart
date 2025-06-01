import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static bool _isLoaded = false;

  static String get projectId =>
      _isLoaded ? (dotenv.env['PROJECT_ID'] ?? '') : '';
  static String get messagingSenderId =>
      _isLoaded ? (dotenv.env['MESSAGING_SENDER_ID'] ?? '') : '';
  static String get storageBucket =>
      _isLoaded ? (dotenv.env['STORAGE_BUCKET'] ?? '') : '';

  static String get webApiKey =>
      _isLoaded ? (dotenv.env['WEB_API_KEY'] ?? '') : '';
  static String get webAppId =>
      _isLoaded ? (dotenv.env['WEB_APP_ID'] ?? '') : '';
  static String get webAuthDomain =>
      _isLoaded ? (dotenv.env['AUTH_DOMAIN'] ?? '') : '';

  static String get androidApiKey =>
      _isLoaded ? (dotenv.env['ANDROID_API_KEY'] ?? '') : '';
  static String get androidAppId =>
      _isLoaded ? (dotenv.env['ANDROID_APP_ID'] ?? '') : '';

  static String get iosApiKey =>
      _isLoaded ? (dotenv.env['IOS_API_KEY'] ?? '') : '';
  static String get iosAppId =>
      _isLoaded ? (dotenv.env['IOS_APP_ID'] ?? '') : '';
  static String get iosBundleId =>
      _isLoaded ? (dotenv.env['IOS_BUNDLE_ID1'] ?? '') : '';

  static String get macosApiKey =>
      _isLoaded ? (dotenv.env['MACOS_API_KEY'] ?? '') : '';
  static String get macosAppId =>
      _isLoaded ? (dotenv.env['MACOS_APP_ID'] ?? '') : '';
  static String get macosBundleId =>
      _isLoaded ? (dotenv.env['IOS_BUNDLE_ID2'] ?? '') : '';

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: ".env");
      _isLoaded = true;
      debugPrint("Environment variables loaded successfully");
    } catch (e) {
      debugPrint("Error loading .env file: $e");
      debugPrint("Continuing with empty environment variables...");
      _isLoaded = false;
    }
  }
}
