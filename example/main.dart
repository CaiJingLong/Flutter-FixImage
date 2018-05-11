import 'package:fit_image/fit_image.dart';
import 'package:flutter/material.dart';

class Sample extends StatefulWidget {
  @override
  _SampleState createState() => new _SampleState();
}

class _SampleState extends State<Sample> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('FixImage'),
      ),
      body: new ListView.builder(
        itemBuilder: _buildChild,
        itemCount: BoxFit.values.length,
      ),
    );
  }

  Widget _buildChild(BuildContext context, int index) {
    var fit = BoxFit.values[index];

    return new Column(
      children: <Widget>[
        new SizedBox(
          width: 100.0,
          height: 120.0,
          child: new FitImage(
            child: new Image.asset("img/flutter-mark-square-100.png"),
            fit: fit,
          ),
        ),
        new Text('$fit'),
      ],
    );
  }
}
