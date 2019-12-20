import 'package:flutter/material.dart';


class DotPainter extends CustomPainter {
  double dotRadius;
  Color dotColor;
  bool repaintDot = false;
  double blurSigma;

  DotPainter({@required this.dotRadius, @required this.dotColor}) {
    _setBlurSigma();
  }

  void setRadius(double radius) {
    dotRadius = radius;
    _setBlurSigma();
    repaintDot = true;
  }

  void _setBlurSigma() {
    blurSigma = dotRadius / 2;
  }

  void setColor(Color color) {
    dotColor = color;
    repaintDot = true;
  }


  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;

//    canvas.drawRect(
//      rect,
//      Paint()
//        ..color = Colors.blue
//        ..strokeWidth = 3.0
//        ..style = PaintingStyle.fill
//    );

      canvas.drawCircle(Offset(dotRadius, dotRadius),
                        dotRadius,
                        Paint()
                          ..color = dotColor
                          ..strokeWidth = 2.0
                          ..style = PaintingStyle.fill
                          ..maskFilter = MaskFilter.blur(BlurStyle.solid, blurSigma));
  }

  @override
  bool shouldRepaint(DotPainter oldDelegate) {
    return true;
//    if (repaintDot) {
//      repaintDot = false;
//      return true;
//    } else {
//      return false;
//    }
  }
}