import 'dart:io';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScanningPage extends StatefulWidget {
  const BarcodeScanningPage({super.key, required this.title});

  final String title;

  @override
  State<BarcodeScanningPage> createState() => _BarcodeScanningState();
}

class _BarcodeScanningState extends State<BarcodeScanningPage> {
  File? file;
  final ImagePicker picker = ImagePicker();
  late BarcodeScanner barcodeScanner;

  Future<void> chooseImage() async {
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      file = File(image.path);
      performBarcodeScanning();
      setState(() {
        image;
      });
    }
  }

  Future<void> captureImage() async {
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      file = File(image.path);
      performBarcodeScanning();
      setState(() {
        image;
      });
    }
  }

  String result = "";
  performBarcodeScanning() async {
    final inputImage = InputImage.fromFile(file!);
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
  void dispose() {
    // TODO: implement dispose
    barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(16),
              color: Colors.grey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                child: file != null
                    ? Image.file(file!)
                    : Icon(
                        Icons.image,
                        size: 150,
                      ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(16),
              color: Colors.deepPurple.shade300,
              child: Container(
                height: 100,
              ),
            ),
            ElevatedButton(
              onLongPress: captureImage,
              onPressed: chooseImage,
              child: Text("Capture/Choose Image"),
            ),
            Text(result)
          ],
        ),
      ),
    );
  }
}
