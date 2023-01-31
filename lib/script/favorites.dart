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
  List<String> _favorites = [];
  int indexImage = 0;
  String url = '';

  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';

  late bool goToHome;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
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

  void removeFromFavorites(String item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList('favorites') ?? [];
    items.remove(item);

    setState(() {
      _favorites = items;
    });
  }

  Future<void> setWallpaperHome(int index) async {
    setState(() {
      indexImage = index;
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

  Future<void> _addToFavorites(String item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList('favorites') ?? [];
    items.add(item);
    items.toSet().toList();
    prefs.setStringList('favorites', items);

    setState(() {
      _favorites = Set<String>.from(_favorites..add(item)).toList();
      // _favorites = items;
    });
  }

  Future<void> dedsetWallpaperLock(int item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList('favorites') ?? [];
    // items.add(item);
    // items.toSet().toList();
    prefs.setStringList('favorites', items);
    items.clear();

    setState(() {
      // _favorites.clear();
      _favorites = items;
    });
  }

  Future<void> setWallpaperLock(index) async {
    setState(() {
      indexImage = index;
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
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 20),
                      child: Card(
                          child: Column(children: <Widget>[
                        GestureDetector(
                            onTap: () => {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              Favorite(context, indexImage))),
                                },
                            child: SizedBox(
                                height: 200,
                                child: Stack(children: <Widget>[
                                  Hero(
                                    tag: imageListLink[indexImage],
                                    child: Image.network(
                                        '${_favorites[index]}grid_0_640_N.webp',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 120),
                                  ),
                                  Row(children: [
                                    _wallpaperUrlHome != 'Loading' &&
                                            indexImage == index
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              HapticFeedback.mediumImpact();
                                              setWallpaperHome(index);
                                            },
                                            child: const Icon(Icons.fit_screen),
                                          )
                                        : const CircularProgressIndicator(),
                                    _wallpaperUrlLock != 'Loading'
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              HapticFeedback.mediumImpact();
                                              setWallpaperLock(index);
                                            },
                                            child: const Icon(
                                                Icons.screen_lock_landscape),
                                          )
                                        : const CircularProgressIndicator(),
                                    ElevatedButton(
                                      onPressed: () async {
                                        HapticFeedback.mediumImpact();
                                        dedsetWallpaperLock(index);
                                      },
                                      child: const Icon(Icons.deblur),
                                    )
                                  ])
                                ]))),
                      ])),
                    );
                  }),
            ])));
  }
}