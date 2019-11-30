import 'package:flutter/material.dart';

import 'dot_painter.dart';

class PegWidget extends StatelessWidget {
  double _radius;
  int width;
  double _dotWidth;
  Color color;

  PegWidget({@required this.width, @required this.color}) {
    _dotWidth = width - 4.0;      // Account for padding
    _radius = _dotWidth / 2;
//    print('dot width: $_dotWidth');
//    print('radius: $_radius');
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {

        return Container(
          padding: EdgeInsets.all(2.0),
//      decoration: BoxDecoration(
//        border: Border.all(
//          color: Colors.grey,
//          width: 1.0
//        )
//      ),
          child: CustomPaint(
            size: Size.square(_dotWidth),
            painter: DotPainter(dotRadius: _radius, dotColor: color),
          ),
        );
      }
    );
  }
}