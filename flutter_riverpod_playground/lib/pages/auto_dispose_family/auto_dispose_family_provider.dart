import 'package:flutter_riverpod/flutter_riverpod.dart';

final autoDisposeFamilyHelloProvider =
    Provider.autoDispose.family<String, String>((ref, name) {
  ref.onDispose(() {
    print('[autoDisposeFamilyHelloProvider]$name is disposed');
  });
  return "Hello $name";
});
