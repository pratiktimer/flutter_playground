import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_playground/pages/family/family_provider.dart';

class FamilyPage extends ConsumerWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helloJohn = ref.watch(familyHelloProvider('John'));
    final helloJane = ref.watch(familyHelloProvider('Jane'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('FamilyProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              helloJohn,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              helloJane,
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
      ),
    );
  }
}
