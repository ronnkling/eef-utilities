import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/DecompModel.dart';
import 'uiHelper.dart';

class DecompView extends StatelessWidget {
  DecompView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decomp = context.watch<DecompModel>();
    return ListView(children: <Widget>[]);
  }
}
