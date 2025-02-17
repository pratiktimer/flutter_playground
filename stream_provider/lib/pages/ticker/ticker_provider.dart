import 'package:flutter_riverpod/flutter_riverpod.dart';

// final tickerProvider = StreamProvider<int>((ref) {
//   ref.onDispose(() {
//     print('[ticketProvider] is disposed');
//   });

//   return Stream.periodic(const Duration(seconds: 1), (t) => t + 1);
// });

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'ticker_provider.g.dart';

@riverpod
Stream<int> ticker(Ref ref) {
  ref.onDispose(() {
    print('[ticketProvider] is disposed');
  });

  return Stream.periodic(const Duration(seconds: 1), (t) => t + 1);
}
