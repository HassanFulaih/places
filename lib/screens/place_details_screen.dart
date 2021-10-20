import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places/models/place.dart';

import 'map_screen.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final String? id;
  final String? title;
  final String? desc;
  final File image;
  final PlaceLocation location;

  const PlaceDetailsScreen(
      this.id, this.title, this.desc, this.image, this.location,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title == null ? null : Text(title!)),
      body: SafeArea(
        child: title == null
            ? Container(height: 0)
            : ListView(
                children: [
                  const SizedBox(height: 10),
                  buildImage(image),
                  const SizedBox(height: 10),
                  buildCard(title!, desc!, context),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[900],
        onPressed: () {
          Navigator.pop(context, id!);
        },
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  Widget buildImage(File image) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Hero(
          tag: id!,
          child: Image.file(image),
        ),
      ),
    );
  }

  Card buildCard(String title, String desc, BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(7),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
            ),
            const Divider(color: Colors.black),
            Text(desc,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,),
            const Divider(color: Colors.black),
            Text(
              location.address,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const Divider(color: Colors.black),
            TextButton(
              child: const Text('View on Map'),
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => MapScreen(
                      initialLocation: location,
                      isSelecting: false,
                    ),
                  ),
                );
              },
            ),
            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
