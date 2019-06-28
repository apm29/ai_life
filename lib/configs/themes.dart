import 'package:flutter/material.dart';

const APP_DEFAULT_DECO = BoxDecoration(gradient: LinearGradient(
  stops: [0.1, 0.9],
  colors: [Colors.purple, Colors.lightBlue],));

ImageLoadingBuilder APP_DEFAULT_LOADING_BUILDER = (BuildContext context, Widget child,ImageChunkEvent chunk) {
  if (chunk == null)
    return child;
  else
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.lightBlue
          ],
          stops: [
            chunk.cumulativeBytesLoaded /
                chunk.expectedTotalBytes,
            0.95
          ],
        ),
      ),
    );
};