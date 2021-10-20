import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:places/models/place.dart';

import '../providers/great_places.dart';
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng, address: '');
  }

  void _savePlace() {
    if (_titleController.text.isEmpty) {
      _showToast('Plaese add a title');
      return;
    }
    if (_descController.text.isEmpty) {
      _showToast('Plaese add a description');
      return;
    }
    if (_pickedImage == null) {
      _showToast('Plaese pick a picture');
      return;
    }
    if (_pickedLocation == null) {
      _showToast('Plaese pick a location');
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false).addPlace(
        _titleController.text,
        _descController.text,
        _pickedImage!,
        _pickedLocation!);
    Navigator.of(context).pop();
  }

  _showToast(String message) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: const StyledToastPosition(
          align: Alignment.bottomCenter, offset: 44.0),
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
      textStyle: const TextStyle(color: Colors.black, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(labelText: 'Title'),
                        controller: _titleController,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        controller: _descController,
                      ),
                      const SizedBox(height: 10),
                      ImageInput(_selectImage),
                      const SizedBox(height: 10),
                      LocationInput(_selectPlace),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
              onPressed: _savePlace,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
