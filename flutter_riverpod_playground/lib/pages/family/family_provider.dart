import 'package:flutter_riverpod/flutter_riverpod.dart';

final familyHelloProvider = Provider.family<String, String>((ref, name) {
  ref.onDispose((){
    print('[familyHelloProvider]$name is disposed');
  });
  return "Hello $name";
});
