import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MobileImExampleApp());
}

class MobileImExampleApp extends StatelessWidget {
  const MobileImExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobileIMSDK Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.indigo,
        useMaterial3: true,
        // colorSchemeSeed: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}
