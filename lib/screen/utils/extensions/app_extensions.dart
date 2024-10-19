import 'package:flutter/material.dart';



extension Responsive on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;
  ColorScheme get themeColors => Theme.of(this).colorScheme;
  Size get deviceSize => MediaQuery.of(this).size;

  Orientation get deviceOrientation => MediaQuery.of(this).orientation;
}




