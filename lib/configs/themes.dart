import 'package:flutter/material.dart';
import 'dart:math';

const APP_DEFAULT_DECO = BoxDecoration(
    gradient: LinearGradient(
  stops: [0.1, 0.9],
  colors: [Colors.purple, Colors.lightBlue],
));

final ImageLoadingBuilder APP_DEFAULT_LOADING_BUILDER =
    (BuildContext context, Widget child, ImageChunkEvent chunk) {
  if (chunk == null) {
    return child;
  } else {
    var percent = chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes;
    var stop = (percent+0.5).clamp(0.5, 1.0);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ Colors.lightBlue,Colors.purple,],
          stops: [percent, stop],
        ),
      ),
    );
  }
};
