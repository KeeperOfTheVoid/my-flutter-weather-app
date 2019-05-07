import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image.asset(
            'assets/weather-bk_enlarged.png',
            fit: BoxFit.cover,
          ),

          new ClipOval(
            clipper: new CircleClipper(
              radius: 140.0,
              offset: const Offset(40.0, 0.0),
            ),
            child: new Image.asset(
              'assets/weather-bk.png',
              fit: BoxFit.cover,
            ),
          ),

          new CustomPaint(
            painter: new WhiteCircleCutoutPainter(
              centerOffset: const Offset(40.0, 0.0),
              circles: [
                new Circle(radius: 140.0, alpha: 0x10),
                new Circle(radius: 140.0 + 15.0, alpha: 0x28),
                new Circle(radius: 140.0 + 30.0, alpha: 0x38),
                new Circle(radius: 140.0 + 75.0, alpha: 0x50),
              ]
            ),

            child: new Container(),
          ),
        ],
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {

  final double radius;
  final Offset offset;

  CircleClipper({
    this.radius,
    this.offset = const Offset(0.0, 0.0),
  });

  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: new Offset(0.0, size.height / 2) + offset,
      radius: radius,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}

class WhiteCircleCutoutPainter extends CustomPainter {

  final Color overlayColor = const Color(0xFFAA88AA);

  final List<Circle> circles;
  final Offset centerOffset;
  final Paint whitePaint;

  WhiteCircleCutoutPainter({
    this.circles = const[],
    this.centerOffset = const Offset(0.0, 0.0),
  }) : whitePaint = new Paint();

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 1; i < circles.length; ++i) {

      _maskCircle(canvas, size, circles[i-1].radius);

      whitePaint.color = overlayColor.withAlpha(circles[i - 1].alpha);

      // Fill circle
      canvas.drawCircle(
          new Offset(0.0, size.height / 2) + centerOffset,
          circles[i].radius,
          whitePaint,
      );
    }

    // Mask area of final circle
    _maskCircle(canvas, size, circles.last.radius);

    // Draw an overlay that fills the rest of the screen
    whitePaint.color = overlayColor.withAlpha(circles.last.alpha);
    canvas.drawRect(
        new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        whitePaint
    );
  }

  _maskCircle(Canvas canvas, Size size, double radius) {
    Path clippedCircle = new Path();

    // If you want to clip a path, you need to start with a larger space.
    // Start with the entire screen, then cut out a circle we want to mask.
    clippedCircle.fillType = PathFillType.evenOdd;
    clippedCircle.addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    clippedCircle.addOval(
      new Rect.fromCircle(
        center: new Offset(0.0, size.height / 2) + centerOffset,
        radius: radius,
      ),
    );
    
    canvas.clipPath(clippedCircle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class Circle {

  final double radius;
  final int alpha;

  Circle({
    this.radius,
    this.alpha = 0xFF,
  });



}