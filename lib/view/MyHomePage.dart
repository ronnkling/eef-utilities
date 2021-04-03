import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import '../model/Samples.dart';
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
            ChangeNotifierProvider(
              create: (context) => Samples(),
              child: SamplesPage().alignment(Alignment.center),
            ),
            LoadFilePage().alignment(Alignment.center),
            ConfigPage().alignment(Alignment.center),
          ],
        ),
      ),
    );
  }
}
