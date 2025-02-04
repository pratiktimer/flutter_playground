import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'basic_provider.g.dart';

final counterProvider = StateProvider<int>((ref) {
  ref.onDispose(() {
    print('[counterProvider] is disposed');
  });
  return 0;
});

@Riverpod(keepAlive: true)
String age(Ref ref) {
  final age = ref.watch(counterProvider);
  ref.onDispose(() {
    print('[ageProvider] is disposed');
  });
  return 'Hi i am $age years old !';
}
