import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'SamplesPage.dart';
import 'LoadFilePage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
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
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SamplesPage().alignment(Alignment.center),
            LoadFilePage().alignment(Alignment.center),
          ],
        ),
      ),
    );
  }
}
