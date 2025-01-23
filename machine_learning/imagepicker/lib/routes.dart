import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imagepicker/barcode_scanning_page.dart';
import 'package:imagepicker/image_labeling_page.dart';
import 'package:imagepicker/live_camera_image_labeling.dart';
import 'package:imagepicker/live_camera_page.dart';

import 'home_page.dart';
import 'image_picker_page.dart';
import 'live_camera_barcode_scanning.dart';

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
            return const ImagePickerPage(
              title: 'Image Picker',
            );
          },
        ),
        GoRoute(
          path: 'livecamera',
          builder: (BuildContext context, GoRouterState state) {
            return const LiveCameraPage();
          },
        ),
        GoRoute(
          path: 'imagelabeling',
          builder: (BuildContext context, GoRouterState state) {
            return const ImageLabelingPage(title: 'Image Labeling');
          },
        ),
        GoRoute(
          path: 'livecameraimagelabeling',
          builder: (BuildContext context, GoRouterState state) {
            return const LiveCameraImageLabelingPage();
          },
        ),
        GoRoute(
          path: 'barcodescanning',
          builder: (BuildContext context, GoRouterState state) {
            return const BarcodeScanningPage(title: '');
          },
        ),
        GoRoute(
          path: 'livebarcodescanning',
          builder: (BuildContext context, GoRouterState state) {
            return const LiveCameraBarcodeScanningPage();
          },
        ),
      ],
    ),
  ],
);
