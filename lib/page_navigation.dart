import 'package:flutter/material.dart';
import 'package:flutter_playground/models/flutter_widgets_types.dart';
import 'package:flutter_widgets/basics/app_bar.dart';

void navigateToScreen(BuildContext context, WidgetType widgetType) {
  switch (widgetType) {
    case WidgetType.appbar:
    default:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AppBarExample(),
      ));
  }
}
