import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imagepicker/live_camera_page.dart';

import 'home_page.dart';
import 'image_picker_page.dart';


/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'imagepicker',
          builder: (BuildContext context, GoRouterState state) {
            return const ImagePickerPage(title: 'Image Picker',);
          },
        ),
        GoRoute(
          path: 'livecamera',
          builder: (BuildContext context, GoRouterState state) {
            return const LiveCameraPage();
          },
        ),
      ],
    ),
  ],
);