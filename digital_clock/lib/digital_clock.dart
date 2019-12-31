// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:digital_clock/effects/effects_manager.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'peg_widget.dart';
import 'peg_board.dart';
import 'effects/effects_manager.dart';


enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

final borderPerDimension = 4;

final framesPerSecond = 10;

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  int _pegWidth;
  Map<int, PegWidget>   _pegWidgets;
  PegBoard pegBoard = new PegBoard();
  EffectsManager effectsManager = new EffectsManager();

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    _updateTime();
    _updateModel();

    _pegWidgets = {};

    effectsManager.pegBoard = pegBoard;

//    effectsManager.addVerticalLineEffect(150);
    effectsManager.addFlashingBackgroundEffect(125);
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );

       // Update once per second, but make sure to do it at the beginning of each
       // new second, so that the clock is accurate.
//       _timer = Timer(
//         Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
//         _updateTime,
//       );


       // Update 8 times per second, to allow for animations.
      _timer = Timer(
        Duration(milliseconds: _frameDuration),
        _updateTime
      );
    });
  }

  int get _frameDuration => (1 ~/ framesPerSecond) * 1000;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('s').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    _calculatePegWidth(context);

    pegBoard.drawBackground();

    effectsManager.next();

    // Extract time digits
    int h0 = 0;
    int h1 = 0;
    int m0 = 0;
    int m1 = 0;

    if (hour.length < 2) {
      h1 = int.parse(hour[0]);
    } else {
      h0 = int.parse(hour[0]);
      h1 = int.parse(hour[1]);
    }

    if (minute.length < 2) {
      m1 = int.parse(minute[0]);
    } else {
      m0 = int.parse(minute[0]);
      m1 = int.parse(minute[1]);
    }

    pegBoard.drawColon();

    pegBoard.placeNumberOnSlot(0, h0);
    pegBoard.placeNumberOnSlot(1, h1);
    pegBoard.placeNumberOnSlot(2, m0);
    pegBoard.placeNumberOnSlot(3, m1);

//    pegBoard.placeNumberOnSlot(0, 1);
//    pegBoard.placeNumberOnSlot(1, 2);
//    pegBoard.placeNumberOnSlot(2, 3);
//    pegBoard.placeNumberOnSlot(3, 4);

//    pegBoard.placeNumberOnSlot(0, 5);
//    pegBoard.placeNumberOnSlot(1, 6);
//    pegBoard.placeNumberOnSlot(2, 7);
//    pegBoard.placeNumberOnSlot(3, 8);

//    pegBoard.placeNumberOnSlot(0, 4);
//    pegBoard.placeNumberOnSlot(1, 3);
//    pegBoard.placeNumberOnSlot(2, 6);
//    pegBoard.placeNumberOnSlot(3, 9);

    return Container(
      color: colors[_Element.background],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _generatePegColumn(PegBoard.pegHeight, PegBoard.pegWidth)
      )
    );
  }

  void _calculatePegWidth(BuildContext context) {
      final drawingWidth = MediaQuery.of(context).size.width - borderPerDimension;
      _pegWidth = (drawingWidth / (PegBoard.pegWidth + 1)).floor();
  }

  List<Widget> _generatePegColumn(int numRows, int numPegsInRow) {
    List<Widget> rows = [];

    int startingRowId = 0;
    for (int i = 0; i < numRows; i++) {
      rows.add(_generatePegRow(numPegsInRow, startingRowId));
      startingRowId += numPegsInRow;
    }

    return rows;
  }

  Widget _generatePegRow(int numPegs, int startingId) {
    List<Widget> pegs = [];

    for (int i = 0; i < numPegs; i++) {
      final pegId = startingId + i;
      final pegData = pegBoard.getPeg(pegId);

      PegWidget pegWidget = PegWidget(width: _pegWidth, color: pegData.pegColor,);
      pegs.add(pegWidget);
      _pegWidgets[pegId] = pegWidget;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pegs,
    );
  }
}
