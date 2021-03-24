import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:graphic/graphic.dart' as graphic;

class SamplesPage extends StatelessWidget {
  SamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 80),
            const Text('y[0] = rand(),  y[i+1] = y[i] + a * rand()'),
            SizedBox(width: 300),
            OutlinedButton(
              child: const Text('Refresh'),
              onPressed: () {},
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(width: 80),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: '0.2'),
                decoration: InputDecoration(labelText: 'a'),
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
            ),
            SizedBox(width: 80),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: '0.0'),
                decoration: InputDecoration(labelText: 'Xmin'),
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
            ),
            SizedBox(width: 80),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: '100.00'),
                decoration: InputDecoration(labelText: 'Xmax'),
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
            ),
            SizedBox(width: 80),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: '99'),
                decoration: InputDecoration(labelText: 'Intervals'),
                keyboardType: TextInputType.numberWithOptions(),
              ),
            ),
          ],
        ),
        Container(
            width: 400,
            height: 300,
            child: graphic.Chart(
              data: [
                {'time': 0, 'sold': 275},
                {'time': 1, 'sold': 115},
                {'time': 2, 'sold': 120},
                {'time': 3, 'sold': 350},
                {'time': 4, 'sold': 150},
              ],
              scales: {
                'time': graphic.LinearScale(
                  accessor: (map) => map['time'] as num,
                ),
                'sold': graphic.LinearScale(
                  accessor: (map) => map['sold'] as num,
                  nice: true,
                )
              },
              geoms: [
                graphic.LineGeom(
                  position: graphic.PositionAttr(field: 'time*sold'),
                )
              ],
              axes: {
                'time': graphic.Defaults.horizontalAxis,
                'sold': graphic.Defaults.verticalAxis,
              },
            )),
      ],
    );
  }
}
