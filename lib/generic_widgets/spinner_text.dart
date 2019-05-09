import 'package:flutter/material.dart';

class SpinnerText extends StatefulWidget {

  final String text;

  SpinnerText({
    this.text = '',
  });

  @override
  _SpinnerTextState createState() => _SpinnerTextState();
}

class _SpinnerTextState extends State<SpinnerText> with SingleTickerProviderStateMixin{

  String topText = '';
  String bottomText = '';

  AnimationController _spinTextAnimationController;
  Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();

    bottomText = widget.text;
    
    _spinTextAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    )
    ..addListener(() => setState((){}))
    ..addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed) {
        setState(() {
          bottomText = topText;
          topText = '';
          _spinTextAnimationController.value = 0.0;
        });
      }
    });

    // An Animation Object is used so we can use the Curve functionality
    _spinAnimation = new CurvedAnimation(
      parent: _spinTextAnimationController,
      curve: Curves.elasticInOut,
    );
  }


  @override
  void dispose() {
    _spinTextAnimationController.dispose();
    super.dispose();
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
          translation: new Offset(0.0, _spinAnimation.value - 1.0),
          child: new Text(
            topText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        new FractionalTranslation(
          translation: new Offset(0.0, _spinAnimation.value),
          child: new Text(
            bottomText,
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
