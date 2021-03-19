import 'package:eefapp/model/EEFConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = context.watch<EEFConfig>();
    return ListView(children: <Widget>[
      ListTile(
          leading: Switch(
            value: config.scaleUp,
            onChanged: (value) {},
          ),
          title: const Text('Scale up or scale down')),
      ListTile(
          leading: Switch(
            value: config.upShowSegment,
            onChanged: (value) {},
          ),
          title: const Text('Show inflexion segment for scale up')),
      ListTile(
          leading: Switch(
            value: config.downCurvature,
            onChanged: (value) {},
          ),
          title: const Text('Use curvature (or change rate) for scaledown')),
      ListTile(
          leading: Switch(
            value: config.adjustEnds,
            onChanged: (value) {},
          ),
          title: const Text('Adjust end points')),
      ListTile(
        title: const Text('Spline function'),
        trailing: Row(children: [
          RadioListTile<SplineFn>(
            title: const Text('Cubic spline'),
            value: SplineFn.cubicSpline,
            groupValue: config.splineFn,
            onChanged: (value) {},
          ),
          RadioListTile<SplineFn>(
            title: const Text('Quintic spline'),
            value: SplineFn.quinticSplice,
            groupValue: config.splineFn,
            onChanged: (value) {},
          ),
          RadioListTile<SplineFn>(
            title: const Text('Cos series'),
            value: SplineFn.cosSeries,
            groupValue: config.splineFn,
            onChanged: (value) {},
          ),
          RadioListTile<SplineFn>(
            title: const Text('Sin series'),
            value: SplineFn.sinSeries,
            groupValue: config.splineFn,
            onChanged: (value) {},
          ),
        ]),
      ),
      ListTile(
          leading: Switch(
            value: config.showCntrlPoints,
            onChanged: (value) {},
          ),
          title: const Text('Show control points')),
      ListTile(
          leading: Switch(
            value: config.showContiguous,
            onChanged: (value) {},
          ),
          title: const Text('Show contiguous component')),
      ListTile(
        title: const Text('Max components'),
        trailing: Slider(
          value: config.components.toDouble(),
          min: 1,
          max: 15,
          divisions: 14,
          onChanged: (value) {},
        ),
      ),
      Row(
        children: [
          OutlinedButton(
            child: const Text('Default Setting'),
            onPressed: () {},
          ),
          SizedBox(width: 60),
          OutlinedButton(
            child: const Text('Help'),
            onPressed: () {},
          ),
          SizedBox(width: 60),
          OutlinedButton(
            child: const Text('About'),
            onPressed: () {},
          ),
        ],
      )
    ]);
  }
}
