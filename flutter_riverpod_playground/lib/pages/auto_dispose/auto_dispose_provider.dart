import 'package:flutter_riverpod/flutter_riverpod.dart';

final autoDisposeHelloProvider = Provider.autoDispose<String>((ref) {
  print('[autoDisposeHelloProvider] created');
  ref.onDispose(() {
    print('[autoDisposeHelloProvider] disposed');
  });
  return 'Hello';
});

final autoDisposeWorldProvider = Provider.autoDispose<String>((ref) {
  print('[autoDisposeWorldProvider] created');
  ref.onDispose(() {
    print('[autoDisposeWorldProvider] disposed');
  });
  return 'World';
});
