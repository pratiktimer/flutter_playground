import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_provder/pages/family/family_provider.dart';

class FamilyPage extends ConsumerWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incValue = ref.watch(familyCounterProvider(10));
    final decValue = ref.watch(familyCounterProvider(-10));

    return Scaffold(
      appBar: AppBar(
        title: const Text('FamilyStateProvider'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$incValue'),
              SizedBox(
                width: 20,
              ),
              FilledButton(
                  onPressed: () {
                    ref
                        .read(familyCounterProvider(10).notifier)
                        .update((state) => state + 10);
                  },
                  child: Icon(Icons.add))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$decValue'),
              SizedBox(
                width: 20,
              ),
              FilledButton(
                  onPressed: () {
                    ref
                        .read(familyCounterProvider(-10).notifier)
                        .update((state) => state - 10);
                  },
                  child: Icon(Icons.remove))
            ],
          )
        ],
      )),
    );
  }
}
