import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_dispose_provider.g.dart';

// final autoDisposeHelloProvider = Provider.autoDispose<String>((ref) {
//   print('[autoDisposeHelloProvider] created');
//   ref.onDispose(() {
//     print('[autoDisposeHelloProvider] disposed');
//   });
//   return 'Hello';
// });

// final autoDisposeWorldProvider = Provider.autoDispose<String>((ref) {
//   print('[autoDisposeWorldProvider] created');
//   ref.onDispose(() {
//     print('[autoDisposeWorldProvider] disposed');
//   });
//   return 'World';
// });

@riverpod
String autoDisposeHello(Ref ref) {
  print('[autoDisposeHelloProvider] created');
  ref.onDispose(() {
    print('[autoDisposeHelloProvider] disposed');
  });
  return 'Hello';
}

@riverpod
String autoDisposeWorld(Ref ref) {
  print('[autoDisposeWorldProvider] created');
  ref.onDispose(() {
    print('[autoDisposeWorldProvider] disposed');
  });
  return 'World';
}
