import 'package:flutter/material.dart';
import 'SamplesPage.dart';
import 'LoadFilePage.dart';
import 'ConfigPage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.insert_chart_sharp),
                text: 'Samples',
              ),
              Tab(
                icon: Icon(Icons.upload_file),
                text: 'Load File',
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
                text: 'Config',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: SamplesPage(),
            ),
            Center(
              child: LoadFilePage(),
            ),
            Center(
              child: ConfigPage(),
            ),
          ],
        ),
      ),
    );
  }
}
