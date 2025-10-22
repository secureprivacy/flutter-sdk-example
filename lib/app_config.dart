import 'dart:io';

class AppConfig {
  const AppConfig._();

  static const applicationIdAndroid = "";
  static const applicationIdIOS = "";
  static const secondaryApplicationIdAndroid = "";
  static const secondaryApplicationIdIOS = "";

  static final primaryAppId = Platform.isAndroid
      ? AppConfig.applicationIdAndroid
      : Platform.isIOS
      ? AppConfig.applicationIdIOS
      : "";

  static final secondaryAppId = Platform.isAndroid
      ? AppConfig.secondaryApplicationIdAndroid
      : Platform.isIOS
      ? AppConfig.secondaryApplicationIdIOS
      : "";
}
