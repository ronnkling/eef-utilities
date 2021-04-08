import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Samples.dart';
import '../model/DecompModel.dart';
import 'SamplesView.dart';
import 'DecompView.dart';

class SamplesPage extends StatelessWidget {
  SamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Samples()),
          ChangeNotifierProvider(create: (context) => DecompModel()),
        ],
        child: ListView(children: <Widget>[
          SamplesView(),
          DecompView(),
        ]));
  }
}
