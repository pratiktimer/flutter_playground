import 'package:flutter/material.dart';
import 'package:flutter_playground/page_navigation.dart';
import 'models/flutter_topics.dart';
import 'models/flutter_widgets_types.dart';

class SubCategoriesApp extends StatelessWidget {
  final FlutterTopic flutterTopic;

  const SubCategoriesApp(this.flutterTopic, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Basic widgets'),
          ),
          body: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: getWidgetTypes(flutterTopic).length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    navigateToScreen(
                        context, getWidgetTypes(flutterTopic)[index]);
                  },
                  child: Container(
                    color:
                        Colors.amber[getWidgetTypes(flutterTopic)[index].color],
                    height: 50,
                    child: Center(
                        child: Text(getWidgetTypes(flutterTopic)[index].name)),
                  ),
                );
              })),
    );
  }
}
