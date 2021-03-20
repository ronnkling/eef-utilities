import 'package:eefapp/model/EEFConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = context.watch<EEFConfig>();
    return ListView(children: [
      ListTile(
          leading: Switch(
            value: config.scaleUp,
            onChanged: (value) => config.setScaleUp(value),
          ),
          title: const Text('Scale up or scale down')),
      ListTile(
          leading: Switch(
            value: config.upShowSegment,
            onChanged: (value) => config.setUpShowSegment(value),
          ),
          title: const Text('Show inflexion segment for scale up')),
      ListTile(
          leading: Switch(
            value: config.downCurvature,
            onChanged: (value) => config.setDownCurvature(value),
          ),
          title: const Text('Use curvature (or change rate) for scaledown')),
      ListTile(
          leading: Switch(
            value: config.adjustEnds,
            onChanged: (value) => config.setAdjustEnds(value),
          ),
          title: const Text('Adjust end points')),
      Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(children: [
          RadioListTile<SplineFn>(
            title: const Text('Cubic spline'),
            value: SplineFn.cubicSpline,
            groupValue: config.splineFn,
            onChanged: (value) => config.setSplineFn(value),
          ),
          RadioListTile<SplineFn>(
            title: const Text('Quintic spline'),
            value: SplineFn.quinticSplice,
            groupValue: config.splineFn,
            onChanged: (value) => config.setSplineFn(value),
          ),
          RadioListTile<SplineFn>(
            title: const Text('Cos series'),
            value: SplineFn.cosSeries,
            groupValue: config.splineFn,
            onChanged: (value) => config.setSplineFn(value),
          ),
          RadioListTile<SplineFn>(
            title: const Text('Sin series'),
            value: SplineFn.sinSeries,
            groupValue: config.splineFn,
            onChanged: (value) => config.setSplineFn(value),
          ),
        ]),
      ),
      ListTile(
          leading: Switch(
            value: config.showCntrlPoints,
            onChanged: (value) => config.setShowCntrlPoints(value),
          ),
          title: const Text('Show control points')),
      ListTile(
          leading: Switch(
            value: config.showContiguous,
            onChanged: (value) => config.setShowContiguous(value),
          ),
          title: const Text('Show contiguous component')),
      ListTile(
        leading: Container(
          width: 400,
          child: Slider(
            value: config.maxComponents.toDouble(),
            label: '${config.maxComponents}',
            min: 1,
            max: 15,
            divisions: 14,
            onChanged: (value) => config.setMaxComponents(value.toInt()),
          ),
        ),
        title: const Text('Max components'),
      ),
      Row(
        children: [
          SizedBox(width: 80),
          OutlinedButton(
            child: const Text('Default Setting'),
            onPressed: () => config.setDefaults(),
          ),
          SizedBox(width: 100),
          OutlinedButton(
            child: const Text('Help'),
            onPressed: () {},
          ),
          SizedBox(width: 100),
          OutlinedButton(
            child: const Text('About'),
            onPressed: () {},
          ),
        ],
      )
    ]);
  }
}
