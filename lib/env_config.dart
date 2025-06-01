import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const projectId = String.fromEnvironment('PROJECT_ID');
  static const messagingSenderId =
      String.fromEnvironment('MESSAGING_SENDER_ID');
  static const storageBucket = String.fromEnvironment('STORAGE_BUCKET');

  static const webApiKey = String.fromEnvironment('WEB_API_KEY');
  static const webAppId = String.fromEnvironment('WEB_APP_ID');
  static const webAuthDomain = String.fromEnvironment('AUTH_DOMAIN');

  static const androidApiKey = String.fromEnvironment('ANDROID_API_KEY');
  static const androidAppId = String.fromEnvironment('ANDROID_APP_ID');

  static const iosApiKey = String.fromEnvironment('IOS_API_KEY');
  static const iosAppId = String.fromEnvironment('IOS_APP_ID');
  static const iosBundleId = String.fromEnvironment('IOS_BUNDLE_ID1');

  static const macosApiKey = String.fromEnvironment('MACOS_API_KEY');
  static const macosAppId = String.fromEnvironment('MACOS_APP_ID');
  static const macosBundleId = String.fromEnvironment('IOS_BUNDLE_ID2');

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: ".env");
      debugPrint("Environment variables loaded successfully");
    } catch (e) {
      debugPrint("Error loading .env file: $e");
    }
  }
}
