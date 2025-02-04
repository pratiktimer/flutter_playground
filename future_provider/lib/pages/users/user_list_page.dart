import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider/pages/users/user_detail_page.dart';
import 'package:future_provider/pages/users/users_providers.dart';

class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(userListProvider);
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: users.when(
          skipLoadingOnRefresh: false,
          data: (userList) => RefreshIndicator(
                color: Colors.red,
                onRefresh: () async {
                  ref.invalidate(userListProvider);
                },
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      var user = userList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  UserDetailPage(userDetailID: user.id)));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(user.id.toString()),
                          ),
                          title: Text(user.name),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => Divider(),
                    itemCount: userList.length),
              ),
          error: (e, st) => Text('$st'),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }
}
