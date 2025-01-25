// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_dispose_family_provider.g.dart';

// final autoDisposeFamilyHelloProvider =
//     Provider.autoDispose.family<String, String>((ref, name) {
//   ref.onDispose(() {
//     print('[autoDisposeFamilyHelloProvider]$name is disposed');
//   });
//   return "Hello $name";
// });

// final autoDisposeFamilyHelloProvider =
//     Provider.autoDispose.family<String, String>((ref, name) {
//   ref.onDispose(() {
//     print('[autoDisposeFamilyHelloProvider]$name is disposed');
//   });
//   return 'Hello $name';
// });

@riverpod
String autoDisposeFamilyHello(Ref ref, String username) {
  ref.onDispose(() {
    print('[autoDisposeFamilyHelloProvider]$username is disposed');
  });
  return "Hello $username";
}
