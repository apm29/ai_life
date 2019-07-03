import 'package:flutter/material.dart';

BoxDecoration appDeco(BuildContext context) => BoxDecoration(
      gradient: LinearGradient(
        stops: [0.1, 0.9],
        colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary,],
      ),
    );

final ImageLoadingBuilder kAppDefaultLoadingBuilder =
    (BuildContext context, Widget child, ImageChunkEvent chunk) {
  if (chunk == null) {
    return child;
  } else {
    var percent = chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes;
    var stop = (percent + 0.5).clamp(0.5, 1.0);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlue,
            Colors.purple,
          ],
          stops: [percent, stop],
        ),
      ),
    );
  }
};
