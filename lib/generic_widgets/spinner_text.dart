import 'package:flutter/material.dart';

class SpinnerText extends StatefulWidget {

  final String text;

  SpinnerText({
    this.text = '',
  });

  @override
  _SpinnerTextState createState() => _SpinnerTextState();
}

class _SpinnerTextState extends State<SpinnerText> {


  String topText = '';
  String bottomText = '';
  

  @override
  void initState() {
    super.initState();

    bottomText = widget.text;
  }

  @override
  void didUpdateWidget(SpinnerText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.text != oldWidget.text) {
      // Need to spin new value down
      topText = widget.text;

      // TODO Run animation
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new FractionalTranslation(
          translation: new Offset(0.0, -1.0),
          child: new Text(
            'top text',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        new FractionalTranslation(
          translation: new Offset(0.0, 0.0),
          child: new Text(
            'bottom text',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
