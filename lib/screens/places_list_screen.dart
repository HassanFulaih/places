import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../screens/place_details_screen.dart';
import './add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  Future<void> _onRefresh(context) async {
    Provider.of<GreatPlaces>(context, listen: false).fetchAndSetPlaces();
  }

  // Test

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                child: const Center(
                  child: Text('Got no places yet, start adding some!'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.isEmpty
                    ? Center(child: ch)
                    : SafeArea(
                        child: RefreshIndicator(
                          onRefresh: () => _onRefresh(context),
                          child: ListView.builder(
                            itemCount: greatPlaces.items.length,
                            itemBuilder: (ctx, i) => ListTile(
                              leading: Hero(
                                tag: greatPlaces.items[i].id,
                                child: CircleAvatar(
                                  backgroundImage: FileImage(
                                    greatPlaces.items[i].image,
                                  ),
                                ),
                              ),
                              title:
                                  Text(greatPlaces.items[i].title, maxLines: 1),
                              subtitle:
                                  Text(greatPlaces.items[i].location!.address),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                      builder: (ctx) => PlaceDetailsScreen(
                                        greatPlaces.items[i].id,
                                        greatPlaces.items[i].title,
                                        greatPlaces.items[i].description,
                                        greatPlaces.items[i].image,
                                        greatPlaces.items[i].location!,
                                      ),
                                    ))
                                    .then(
                                      (value) => greatPlaces.deletePlace(value),
                                    );
                              },
                            ),
                          ),
                        ),
                      ),
              ),
      ),
      floatingActionButton: Platform.isIOS
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
              label: const Text('Add Palace'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
    );
  }
}
