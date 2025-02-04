import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_dispose_provider.g.dart';

final autoDisposeCounterProvider = StateProvider.autoDispose<int>((ref) {
  ref.onDispose(() {
    print('[autoDisposeCounterProvider] is disposed');
  });
  return 0;
});

@Riverpod(keepAlive: false)
String ageAutoAispose(Ref ref) {
  final age = ref.watch(autoDisposeCounterProvider);
  ref.onDispose(() {
    print('[ageAutoAispose] is disposed');
  });
  return 'Hi i am $age years old !';
}
