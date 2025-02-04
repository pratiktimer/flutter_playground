import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider/models/user.dart';
// import 'package:future_provider/pages/users/user_list_page.dart';
import 'package:future_provider/provider/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'users_providers.g.dart';
// final userListProvider = FutureProvider.autoDispose<List<User>>((ref) async {
//   ref.onDispose(() {
//     print('[userListProvider] is dispose');
//   });

//   final response = await ref.watch(dioProvider).get('/users');

//   final List userList = response.data;

//   final users = [for (final user in userList) User.fromJson(user)];

//   return users;
// });

@riverpod
FutureOr<List<User>> userList(Ref ref) async {
  ref.onDispose(() {
    print('[userListProvider] is dispose');
  });

  final response = await ref.watch(dioProvider).get('/users');
  ref.keepAlive();

  final List userList = response.data;

  final users = [for (final user in userList) User.fromJson(user)];

  return users;
}

// final userDetailProvider =
//     FutureProvider.family<User, int>((ref, int userDetailID) async {
//   ref.onDispose(() {
//     print('[userDetailProvider] is dispose');
//   });

//   final response = await ref.watch(dioProvider).get('/users/$userDetailID');
//   final user = User.fromJson(response.data);
//   return user;
// });

@riverpod
FutureOr<User> userDetail(Ref ref, int userDetailID) async {
  ref.onDispose(() {
    print('[userDetailProvider] is dispose');
  });

  final response = await ref.watch(dioProvider).get('/users/$userDetailID');
  ref.keepAlive();
  final user = User.fromJson(response.data);
  return user;
}
