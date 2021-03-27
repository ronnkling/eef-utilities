import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:eefapp/model/EEFConfig.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = context.watch<EEFConfig>();
    return ListView(children: <Widget>[
      Row(
        children: [
          OutlinedButton(
            child: const Text('Default Setting').bold(),
            onPressed: () => config.setDefaults(),
          ).padding(left: 18),
          Expanded(
            child: SizedBox(width: 100),
          ),
          OutlinedButton(
            child: const Text('Help'),
            onPressed: () {},
          ),
          OutlinedButton(
            child: const Text('About'),
            onPressed: () {},
          ).padding(horizontal: 80),
        ],
      ).padding(vertical: 10),
      Wrap(children: [
        RadioListTile<SplineFn>(
          title: const Text('Cubic spline'),
          value: SplineFn.cubicSpline,
          groupValue: config.splineFn,
          onChanged: (value) => config.setSplineFn(value),
        ).width(150),
        RadioListTile<SplineFn>(
          title: const Text('Quintic spline'),
          value: SplineFn.quinticSplice,
          groupValue: config.splineFn,
          onChanged: (value) => config.setSplineFn(value),
        ).width(150),
        RadioListTile<SplineFn>(
          title: const Text('Cos series'),
          value: SplineFn.cosSeries,
          groupValue: config.splineFn,
          onChanged: (value) => config.setSplineFn(value),
        ).width(150),
        RadioListTile<SplineFn>(
          title: const Text('Sin series'),
          value: SplineFn.sinSeries,
          groupValue: config.splineFn,
          onChanged: (value) => config.setSplineFn(value),
        ).width(150),
      ]).padding(left: 20),
      CheckboxListTile(
          value: config.scaleUp,
          onChanged: (value) => config.setScaleUp(value!),
          title: const Text('Scale up or scale down'),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: config.upShowSegment,
          onChanged: (value) => config.setUpShowSegment(value!),
          title: const Text('Show inflexion segment for scale up'),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: config.downCurvature,
          onChanged: (value) => config.setDownCurvature(value!),
          title: const Text('Use curvature (or change rate) for scaledown'),
          controlAffinity: ListTileControlAffinity.leading),
      CheckboxListTile(
          value: config.adjustEnds,
          onChanged: (value) => config.setAdjustEnds(value!),
          title: const Text('Adjust end points'),
          controlAffinity: ListTileControlAffinity.leading),
      ListTile(
        leading: Slider(
          value: config.maxComponents.toDouble(),
          label: '${config.maxComponents}',
          min: 1,
          max: 15,
          divisions: 14,
          onChanged: (value) => config.setMaxComponents(value.toInt()),
        ).width(400),
        title: const Text('Max components'),
      ),
    ]);
  }
}
