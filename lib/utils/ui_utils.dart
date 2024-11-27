import 'package:flutter/material.dart';

import '../constants/dimension_constants.dart';

void showSnackBar(BuildContext context, {
  required String message,
  Color? color,
  required IconData icon,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: color ?? Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            Icon(icon),
          ],
        ),
      ),
    );
}

double getWidgetWidth({
  required double targetWidgetWidth,
  required double screenWidth,
}) {
  double widthScaleFactor =
      targetWidgetWidth / DimensionsConstants.designedScreenWidth;

  return screenWidth * widthScaleFactor;
}

double getWidgetHeight({
  required double targetWidgetHeight,
  required double screenHeight,
}) {
  double heightScaleFactor =
      targetWidgetHeight / DimensionsConstants.designedScreenHeight;

  return screenHeight * heightScaleFactor;
}