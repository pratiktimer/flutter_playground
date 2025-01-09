import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key, required this.title});

  final String title;

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? file;
  final ImagePicker picker = ImagePicker();

  Future<void> chooseImage() async {
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      file = File(image.path);
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
      setState(() {
        image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            file != null
                ? Image.file(file!)
                : Icon(
              Icons.image,
              size: 150,
            ),
            ElevatedButton(
              onLongPress: captureImage,
              onPressed: chooseImage,
              child: Text("Capture/Choose Image"),
            )
          ],
        ),
      ),
    );
  }
}
