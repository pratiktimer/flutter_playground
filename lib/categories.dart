import 'package:flutter/material.dart';
import 'package:flutter_playground/models/flutter_topics.dart';
import 'package:flutter_playground/sub_categories.dart';

class CategoriesApp extends StatelessWidget {
  const CategoriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Widget catalog'),
          ),
          body: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: flutterTopics.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SubCategoriesApp(flutterTopics[index]),
                    ));
                  },
                  child: Container(
                    color: Colors.amber[flutterTopics[index].color],
                    height: 50,
                    child: Center(child: Text(flutterTopics[index].name)),
                  ),
                );
              })),
    );
  }
}
