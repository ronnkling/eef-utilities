import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'SamplesPage.dart';
import 'CsvFilePage.dart';

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
                text: 'Random Samples',
              ),
              Tab(
                icon: Icon(Icons.upload_file),
                text: 'CSV File Upload',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SamplesPage().alignment(Alignment.center),
            CsvFilePage().alignment(Alignment.center),
          ],
        ),
      ),
    );
  }
}
