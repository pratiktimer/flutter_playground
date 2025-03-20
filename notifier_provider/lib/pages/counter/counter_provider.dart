import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'counter_provider.g.dart';

@Riverpod(keepAlive: true)
class Counter extends _$Counter {
  @override
  int build(int initialValue) {
    ref.onDispose(() {
      print('[counterProvider is disposed]');
    });
    return initialValue;
  }

  void increment() {
    state++;
  }
}

// class Counter extends Notifier<int> {
//   @override
//   build() {
//     ref.onDispose(() {
//       print('[counterProvider is disposed]');
//     });
//     return 0;
//   }

//   void increment() {
//     state++;
//   }
// }

// final counterProvider = NotifierProvider<Counter, int>(Counter.new);

// class Counter extends AutoDisposeNotifier<int> {
//   @override
//   build() {
//     ref.onDispose(() {
//       print('[counterProvider is disposed]');
//     });
//     return 0;
//   }

//   void increment() {
//     state++;
//   }
// }

// final counterProvider = NotifierProvider.autoDispose<Counter, int>(Counter.new);

// class Counter extends FamilyNotifier<int, int> {
//   @override
//   build(int arg) {
//     ref.onDispose(() {
//       print('[counterProvider is disposed]');
//     });
//     return arg;
//   }

//   void increment() {
//     state++;
//   }
// }

// final counterProvider = NotifierProvider.family<Counter, int, int>(Counter.new);

// class Counter extends AutoDisposeFamilyNotifier<int, int> {
//   @override
//   build(int arg) {
//     ref.onDispose(() {
//       print('[counterProvider is disposed]');
//     });
//     return arg;
//   }

//   void increment() {
//     state++;
//   }
// }

// final counterProvider = NotifierProvider.family.autoDispose<Counter, int, int>(
//   Counter.new,
// );
