import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The home screen
class HomePage extends StatelessWidget {
  /// Constructs a [HomePage]
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home Screen')),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/imagepicker'),
                  child: const Text('Go to the Image Picker screen'),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/livecamera'),
                  child: const Text('Go to the Live Camera screen'),
                ),
              ],
            ),
          ),
        ));
  }
}
