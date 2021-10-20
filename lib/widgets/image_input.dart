import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput(this.onSelectImage, {Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile? _storedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture(src) async {
    final XFile? imageFile = await _picker.pickImage(
      source: src,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  File(_storedImage!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Picture'),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                onPressed: ()=>_takePicture(ImageSource.camera),
              ),
              TextButton.icon(
                icon: const Icon(Icons.photo_camera_back),
                label: const Text('Pick from Gallary'),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                onPressed: ()=>_takePicture(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
