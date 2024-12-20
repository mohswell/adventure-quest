import 'package:adventure_quest/activity/data/datasource/activity_local_datasource.dart';
import 'package:adventure_quest/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/activities_model.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<ActivityData> favorites = [];

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  // method to get faviorites form datasource
  Future<void> _getFavorites() async {
    final favoritesStringList = await activityLocalDataSource.getActivity();

    setState(() {
      favorites = favoritesStringList;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ActivitiesNotifier>(builder: (builder, activitiesModel, child) {
        final activities = activitiesModel.activities;

        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final activity = favorites[index];
            return Container(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                // tileColor: ,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  activity.activity,
                ),
                subtitle: Text(
                  activity.type,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () async {
                        activityLocalDataSource.deleteActivity(activity.id!);
                        _getFavorites();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 2);
          },
          itemCount: favorites.length,
        );
      }),
    );
  }
}
