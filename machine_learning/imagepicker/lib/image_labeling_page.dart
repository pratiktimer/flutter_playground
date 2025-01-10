import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelingPage extends StatefulWidget {
  const ImageLabelingPage({super.key, required this.title});

  final String title;

  @override
  State<ImageLabelingPage> createState() => _ImageLabelingPageState();
}

class _ImageLabelingPageState extends State<ImageLabelingPage> {
  File? file;
  final ImagePicker picker = ImagePicker();

  Future<void> chooseImage() async {
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      file = File(image.path);
      performImageLabeling();
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
      performImageLabeling();
      setState(() {
        image;
      });
    }
  }

  String result = "";
  performImageLabeling() async {
    final inputImage = InputImage.fromFile(file!);

    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: options);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += text + "  " + confidence.toStringAsFixed(2) + "\n";
    }
    setState(() {
      result;
    });
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
