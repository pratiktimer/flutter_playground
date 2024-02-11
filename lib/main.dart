import 'package:flutter/material.dart';
import 'package:flutter_playground/categories.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter documentation')),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CategoriesApp(),
                ));
              },
              child: Container(
                height: 100,
                color: Colors.amber[600],
                child: const Center(child: Text('Widget catalog')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
