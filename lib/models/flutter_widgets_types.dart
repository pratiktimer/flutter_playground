import 'package:flutter_playground/models/flutter_topics.dart';

enum WidgetType {
  appbar(600),
  column(500),
  container(100),
  elevatedbutton(200),
  flutterlogo(300),
  icon(400),
  image(700),
  placeholder(800),
  row(900),
  scaffold(600),
  text(500);

  final int color;

  const WidgetType(this.color);
}

final List<WidgetType> _basicWidgets = [
  WidgetType.appbar,
  WidgetType.column,
  WidgetType.container,
  WidgetType.elevatedbutton,
  WidgetType.flutterlogo,
  WidgetType.icon,
  WidgetType.image,
  WidgetType.placeholder,
  WidgetType.row,
  WidgetType.scaffold,
  WidgetType.text
];

List<WidgetType> getWidgetTypes(FlutterTopic topic) {
  switch (topic) {
    case FlutterTopic.accessibility:
    // TODO: Handle this case.
    case FlutterTopic.animationAndMotion:
    // TODO: Handle this case.
    case FlutterTopic.assetsImagesAndIcons:
    // TODO: Handle this case.
    case FlutterTopic.async:
    // TODO: Handle this case.
    case FlutterTopic.basics:
      return _basicWidgets;
    default:
      return _basicWidgets;
  }
}
