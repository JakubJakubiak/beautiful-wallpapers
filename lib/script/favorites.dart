import 'dart:convert';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../image/imageListLink.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Scrol.dart';
import 'favorite.dart';

export 'package:beautifulwallpapers/script/favorites.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<Favorites> {
  List<dynamic> _favorites = [];
  int indexImage = 0;
  String url = '';

  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';

  late bool goToHome;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    goToHome = false;
    indexImage;
    _getFavorites();
  }

  Future<void> _getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList('favorites') ?? [];

    setState(() {
      _favorites = items;
    });
  }

  Future<void> setWallpaperHome(int indexImage) async {
    setState(() {
      url = '${imageListLink[indexImage]}grid_0.png';

      _wallpaperUrlHome = 'Loading';
    });
    String result;

    try {
      result = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    if (!mounted) return;

    setState(() {
      _wallpaperUrlHome = result;
    });
  }

  Future<void> _addToFavorites(String item, int indexImage) async {
    List<String> favorites = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getStringList('favorites') ?? []);

    List favoriteItems = favorites.map((f) => json.decode(f)).toList();

    Map<String, dynamic> newItem = {'link': item};
    bool exists = favoriteItems.any((f) => f['link'] == item);

    if (!exists) {
      favoriteItems.add(newItem);

      favorites = favoriteItems.map((f) => json.encode(f)).toList();
      await SharedPreferences.getInstance()
          .then((prefs) => prefs.setStringList('favorites', favorites));
    }

    setState(() {
      _favorites = favoriteItems;
      print(_favorites);
    });
  }

  Future<void> setWallpaperLock(int indexImage) async {
    setState(() {
      url = '${imageListLink[indexImage]}grid_0.png';
      _wallpaperUrlLock = 'Loading';
    });
    String result;

    try {
      result = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    if (!mounted) return;

    setState(() {
      _wallpaperUrlLock = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: <Widget>[
              ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    int indexImage = index;
                    String link = '';
                    print(_favorites);
                    if (_favorites.isNotEmpty) {
                      Map<String, dynamic> item =
                          json.decode(_favorites[index]);
                      link = item['link'];
                    }
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 20),
                      child: Card(
                          child: Column(children: <Widget>[
                        GestureDetector(
                            onTap: () async => {
                                  HapticFeedback.mediumImpact(),
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              Favorite(context, link, index))),
                                },
                            child: SizedBox(
                                height: 200,
                                child: Stack(children: <Widget>[
                                  Hero(
                                    tag: '$link$index',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: CachedNetworkImage(
                                          imageUrl: '${link}grid_0_640_N.webp',
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error)),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 120),
                                  ),
                                  Row(children: [
                                    _wallpaperUrlHome != 'Loading'
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              HapticFeedback.mediumImpact();
                                              setWallpaperHome(indexImage);
                                            },
                                            child: const Icon(
                                              Icons.fit_screen,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          )
                                        : const CircularProgressIndicator(),
                                    _wallpaperUrlLock != 'Loading'
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              HapticFeedback.mediumImpact();
                                              setWallpaperLock(indexImage);
                                            },
                                            child: const Icon(
                                              Icons.screen_lock_landscape,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                          )
                                        : const CircularProgressIndicator(),
                                  ])
                                ]))),
                      ])),
                    );
                  }),
            ])));
  }
}
