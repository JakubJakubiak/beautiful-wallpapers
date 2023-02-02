import 'dart:convert';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../image/imageListLink.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beautifulwallpapers/script/scrol.dart';

import '../main.dart';
import 'Scrol.dart';
import 'allscript.dart';

export 'package:beautifulwallpapers/script/favorite.dart';

class Favorite extends StatefulWidget {
  final BuildContext context;
  final int indexImage;

  Favorite(
    this.context,
    this.indexImage,
  ) : super(key: UniqueKey());

  @override
  createState() => _ChooseLocationState(indexImage: indexImage);
}

class _ChooseLocationState extends State<Favorite> {
  List<dynamic> _favorites = [];

  int indexImage = 0;

  _ChooseLocationState({required this.indexImage});
  String url = '';

  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';
  bool isInFavoritess = false;

  late bool goToHome;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    goToHome = false;
    _getFavorites();
  }

  Future<void> _getFavorites() async {
    List<String> favorites = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getStringList('favorites') ?? []);

    List favoriteItems = favorites.map((f) => json.decode(f)).toList();
    bool isInFavorites =
        favoriteItems.any((f) => f['link'] == imageListLink[indexImage]);

    setState(() {
      _favorites = favoriteItems;
      isInFavoritess = isInFavorites;
    });
  }

  Future<void> _addToFavorites(String item, int indexImage) async {
    List<String> favorites = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getStringList('favorites') ?? []);

    List favoriteItems = favorites.map((f) => json.decode(f)).toList();

    Map<String, dynamic> newItem = {'id': indexImage, 'link': item};
    bool exists =
        favoriteItems.any((f) => f['id'] == indexImage && f['link'] == item);

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

  // Future<void> deleteetWallpaperLock(int index) async {
  //   await SharedPreferences.getInstance()
  //       .then((prefs) => prefs.remove('favorites'));

  //   setState(() {
  //     _favorites = [];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _getFavorites();

    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(children: <Widget>[
        Scaffold(
            body: Container(
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          Hero(
                            tag: imageListLink[indexImage],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: CachedNetworkImage(
                                  imageUrl:
                                      '${imageListLink[indexImage]}grid_0_640_N.webp',
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error)),
                            ),
                          ),
                          Column(
                              verticalDirection: VerticalDirection.up,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 50.0,
                                    left: 50.0,
                                  ),
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
                                            size: 40,
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
                                            size: 40,
                                          ),
                                        )
                                      : const CircularProgressIndicator(),
                                  isInFavoritess
                                      ? GestureDetector(
                                          onTap: () async {
                                            HapticFeedback.mediumImpact();
                                            Utils.removeFromFavorites(
                                                imageListLink[indexImage],
                                                indexImage);
                                          },
                                          child: const Icon(
                                            Icons.favorite,
                                            size: 40,
                                            color: Color.fromARGB(
                                                255, 217, 17, 17),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            HapticFeedback.mediumImpact();

                                            // await Utils.
                                            _addToFavorites(
                                                imageListLink[indexImage],
                                                indexImage);

                                            // _addToFavorites() async {
                                            //   List favorites =
                                            //       await Utils.addToFavorites(
                                            //           imageListLink[indexImage],
                                            //           indexImage);
                                            //   setState(() {
                                            //     _favorites = favorites;
                                            //     print(_favorites);
                                            //   });
                                            // }
                                          },
                                          child: const Icon(
                                            Icons.favorite_border,
                                            size: 40,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                ])
                              ])
                        ],
                      )),
                ))),
      ]),
    ));
  }
}
