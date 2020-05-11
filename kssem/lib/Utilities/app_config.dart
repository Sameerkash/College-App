import 'dart:math';
import 'package:flutter/material.dart';

class McGyver {

  static const double _fixedWidth = 410;    // Set to an Aspect Ratio of 2:1 (height:width)
  static const double _fixedHeight = 820;   // Set to an Aspect Ratio of 2:1 (height:width) 

  // Useful rounding method (@andyw solution -> https://stackoverflow.com/questions/28419255/how-do-you-round-a-double-in-dart-to-a-given-degree-of-precision-after-the-decim/53500405#53500405)
  static double roundToDecimals(double val, int decimalPlaces){
    double mod = pow(10.0, decimalPlaces);
    return ((val * mod).round().toDouble() / mod);
  }

  // The 'Ratio-Scaled' Widget method (takes any generic widget and returns a "Ratio-Scaled Widget" - "rsW  idget")
  static Widget rsWidget(BuildContext ctx, Widget inWidget, double percWidth, double percHeight) {

    // ---------------------------------------------------------------------------------------------- //
    // INFO: Ratio-Scaled "SizedBox" Widget - Scaling based on device's height & width at 2:1 ratio.  //
    // ---------------------------------------------------------------------------------------------- //

    final int _decPlaces = 5;
    final double _fixedWidth = McGyver._fixedWidth;
    final double _fixedHeight = McGyver._fixedHeight;

    Size _scrnSize = MediaQuery.of(ctx).size;                // Extracts Device Screen Parameters.
    double _scrnWidth = _scrnSize.width.floorToDouble();     // Extracts Device Screen maximum width.
    double _scrnHeight = _scrnSize.height.floorToDouble();   // Extracts Device Screen maximum height.

    double _rsWidth = 0;
    if (_scrnWidth == _fixedWidth) {   // If input width matches fixedWidth then do normal scaling.
      _rsWidth = McGyver.roundToDecimals((_scrnWidth * (percWidth / 100)), _decPlaces);
    } else {   // If input width !match fixedWidth then do adjustment factor scaling.
      double _scaleRatioWidth = McGyver.roundToDecimals((_scrnWidth / _fixedWidth), _decPlaces);
      double _scalerWidth = ((percWidth + log(percWidth + 1)) * pow(1, _scaleRatioWidth)) / 100;
      _rsWidth = McGyver.roundToDecimals((_scrnWidth * _scalerWidth), _decPlaces);
    }

    double _rsHeight = 0;
    if (_scrnHeight == _fixedHeight) {   // If input height matches fixedHeight then do normal scaling.
      _rsHeight = McGyver.roundToDecimals((_scrnHeight * (percHeight / 100)), _decPlaces);
    } else {   // If input height !match fixedHeight then do adjustment factor scaling.
      double _scaleRatioHeight = McGyver.roundToDecimals((_scrnHeight / _fixedHeight), _decPlaces);
      double _scalerHeight = ((percHeight + log(percHeight + 1)) * pow(1, _scaleRatioHeight)) / 100;
      _rsHeight = McGyver.roundToDecimals((_scrnHeight * _scalerHeight), _decPlaces);
    }

    // Finally, hand over Ratio-Scaled "SizedBox" widget to method call.
    return SizedBox(
      width: _rsWidth,
      height: _rsHeight,
      child: inWidget,
    );
  }

}
