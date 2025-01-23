import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:imagepicker/main.dart';

class LiveCameraBarcodeScanningPage extends StatefulWidget {
  const LiveCameraBarcodeScanningPage({super.key});

  @override
  State<LiveCameraBarcodeScanningPage> createState() =>
      _LiveCameraBarcodeScanningPageState();
}

class _LiveCameraBarcodeScanningPageState
    extends State<LiveCameraBarcodeScanningPage> {
  late CameraController controller;
  bool isBusy = false;
  late BarcodeScanner barcodeScanner;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = cameras[0];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  String result = "";
  performBarcodeScanning(InputImage inputImage) async {
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    barcodeScanner = BarcodeScanner(formats: formats);
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      final Rect boundingBox = barcode.boundingBox;
      final String? displayValue = barcode.displayValue;
      final String? rawValue = barcode.rawValue;

      // See API reference for complete list of supported types
      result = displayValue ?? "";
    }
    setState(() {
      result;
    });
  }

  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.max,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((cameraImage) {
        if (!isBusy) {
          isBusy = true;
          var inputImage = _inputImageFromCameraImage(cameraImage);
          if (inputImage != null) {
            performBarcodeScanning(inputImage);
          }
        }
      });
      // setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            controller.value.isInitialized
                ? CameraPreview(controller)
                : SizedBox(),
            Text(
              result,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    ));
  }
}
