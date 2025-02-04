// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:future_provider/pages/users/users_providers.dart';

class UserDetailPage extends ConsumerWidget {
  final int userDetailID;

  UserDetailPage({
    super.key,
    required this.userDetailID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(userDetailProvider(userDetailID));
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
      ),
      body: Center(
        child: userDetail.when(
            data: (user) => ListView(
                  children: [
                    InfoWidget(
                      iconData: Icons.person,
                      value: user.name,
                    ),
                    InfoWidget(
                      iconData: Icons.email,
                      value: user.email,
                    ),
                    InfoWidget(
                      iconData: Icons.web,
                      value: user.website,
                    ),
                    InfoWidget(
                      iconData: Icons.phone,
                      value: user.phone,
                    )
                  ],
                ),
            error: (e, st) => Text('$st'),
            loading: () => Center(child: CircularProgressIndicator())),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final IconData iconData;
  final String value;
  const InfoWidget({
    Key? key,
    required this.iconData,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData),
        SizedBox(
          width: 20,
        ),
        Text(value)
      ],
    );
  }
}
