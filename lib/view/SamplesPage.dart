import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class SamplesPage extends StatelessWidget {
  SamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: '0.0', filled: true, hintText: 'X Min'),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: '100.0', filled: true, hintText: 'X Max'),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: '99', filled: true, hintText: 'Divisions'),
              keyboardType: TextInputType.numberWithOptions(),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: '0.2', filled: true, hintText: 'Factor a'),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            Expanded(
              child: const Text('y[0] = rand(), y[i+1] = y[i] + a * rand()'),
            ),
            OutlinedButton(
              child: const Text('Refresh'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
