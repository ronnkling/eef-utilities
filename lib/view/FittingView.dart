import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/FittingModel.dart';
import 'uiHelper.dart';

class FittingView extends StatelessWidget {
  FittingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fitting = context.watch<FittingModel>();
    return ExpansionTile(title: Text('Curve Fitting'), children: <Widget>[])
        .height(600);
  }
}
