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
import 'allscripts.dart';
import 'package:beautifulwallpapers/script/allscripts.dart';

export 'package:beautifulwallpapers/script/favorite.dart';

class Favorite extends StatefulWidget {
  final BuildContext context;
  final String link;
  final int index;

  Favorite(
    this.context,
    this.link,
    this.index,
  ) : super(key: UniqueKey());

  @override
  createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<Favorite> {
  List<dynamic> _favorites = [];

  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';
  bool isInFavoritess = false;

  late bool goToHome;
  late SharedPreferences prefs;

  String get urlBig => '${widget.link}grid_0.png';
  String get urlLite => '${widget.link}grid_0_640_N.webp';

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
    bool isInFavorites = favoriteItems.any((f) => f['link'] == widget.link);

    setState(() {
      _favorites = favoriteItems;
      isInFavoritess = isInFavorites;
    });
  }

  Future<void> _addToFavorites(String link) async {
    List<String> favorites = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getStringList('favorites') ?? []);

    List favoriteItems = favorites.map((f) => json.decode(f)).toList();

    Map<String, dynamic> newItem = {'link': link};
    bool exists = favoriteItems.any((f) => f['link'] == link);

    if (!exists) {
      favoriteItems.add(newItem);

      favorites = favoriteItems.map((f) => json.encode(f)).toList();
      await SharedPreferences.getInstance()
          .then((prefs) => prefs.setStringList('favorites', favorites));
    }

    setState(() {
      _favorites = favoriteItems;
    });
  }

  Future<void> setWallpaperHome(String link) async {
    setState(() {
      _wallpaperUrlHome = 'Loading';
    });
    String result;

    try {
      result = await AsyncWallpaper.setWallpaper(
        url: urlBig,
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

  Future<void> setWallpaperLock(link) async {
    setState(() {
      _wallpaperUrlLock = 'Loading';
    });
    String result;

    try {
      result = await AsyncWallpaper.setWallpaper(
        url: urlBig,
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
                            tag: '${widget.link}${widget.index}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: CachedNetworkImage(
                                  imageUrl: '${widget.link}grid_0_640_N.webp',
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
                                            if (_wallpaperUrlLock != 'Loading')
                                              setWallpaperHome(widget.link);
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
                                            if (_wallpaperUrlHome != 'Loading')
                                              setWallpaperLock(widget.link);
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
                                                widget.link);
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
                                            _addToFavorites(widget.link);
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
