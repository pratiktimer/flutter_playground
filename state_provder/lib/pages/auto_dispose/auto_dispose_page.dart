import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_provder/pages/auto_dispose/auto_dispose_provider.dart';

class AutoDisposePage extends ConsumerWidget {
  const AutoDisposePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(ageAutoAisposeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StateProvider'),
      ),
      body: Center(
        child: Text('$value'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref
              .read(autoDisposeCounterProvider.notifier)
              .update((state) => state + 10);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
