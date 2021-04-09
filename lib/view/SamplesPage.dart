import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Samples.dart';
import '../model/DecompModel.dart';
import '../model/FittingModel.dart';
import 'SamplesView.dart';
import 'DecompView.dart';
import 'FittingView.dart';

class SamplesPage extends StatelessWidget {
  SamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Samples()),
          ChangeNotifierProvider(create: (context) => DecompModel()),
          ChangeNotifierProvider(create: (context) => FittingModel()),
        ],
        child: ListView(children: <Widget>[
          SamplesView(),
          DecompView(),
          FittingView(),
        ]));
  }
}
