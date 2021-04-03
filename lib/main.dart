import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/MyHomePage.dart';
import 'model/EEFConfig.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => EEFConfig(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EEF App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
