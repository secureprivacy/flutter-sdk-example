import 'package:example_mobile_consent/main_screen.dart';
import 'package:example_mobile_consent/support/sp_styles.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(home: MainScreen(), theme: SPCupertinoStyles.appTheme);
  }
}