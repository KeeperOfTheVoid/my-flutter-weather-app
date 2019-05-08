import 'package:flutter/material.dart';

class WeekDrawer extends StatelessWidget {

  final week = [
    'Tuesday\nAugust 27',
    'Wednesday\nAugust 28',
    'Thursday\nAugust 29',
    'Friday\nAugust 30',
    'Saturday\nAugust 31',
    'Sunday\nAugust 1',
    'Monday\nAugust 2',
  ];

  List<Widget> _buildDayButtons() {
    return week.map((String title) {
      return new Expanded(
        child: new GestureDetector(
          onTap: () {
            // TODO: Finish later
          },
          child: new Text(
            title,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 125.0,
      height: double.infinity,  // As large as container
      color: Color(0xAA234060),
      child: new Column(
        children: <Widget>[
          // Take all vertical space
          new Expanded(
            child: new Icon(
              Icons.refresh,
              color: Colors.white,
              size: 40.0,
            ),
          ),
        ]
          ..addAll(_buildDayButtons()),
      ),
    );
  }
}
