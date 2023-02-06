import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../image/imageListLink.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async_wallpaper/async_wallpaper.dart';

import '../main.dart';
import 'package:beautifulwallpapers/script/favorite.dart';

export 'package:beautifulwallpapers/script/scrol.dart';

class Scrol extends StatefulWidget {
  static int indexImage = 0;
  const Scrol({super.key});

  @override
  createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<Scrol> {
  String url = '';
  int indexImage = 0;

  final ScrollController _controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';

  late bool goToHome;
  late SharedPreferences prefs;
  List<dynamic> _favorites = [];

  @override
  void initState() {
    super.initState();
    goToHome = false;

    initPlatformState();
    _getFavorites();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _getFavorites() async {
    List<String> items = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getStringList('favorites') ?? []);

    setState(() {
      _favorites = items;
    });
  }

  Future<void> setWallpaperHome(String link) async {
    setState(() {
      url = '${link}grid_0.png';
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

  Future<void> setWallpaperLock(link) async {
    setState(() {
      url = '${link}grid_0.png';
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
        key: _scaffoldKey,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            ListView.builder(
                controller: _controller,
                itemCount: imageListLink.length,
                itemBuilder: (context, index) {
                  String link = imageListLink[index];
                  print('$link$index');
                  return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Card(
                          child: Column(children: <Widget>[
                        GestureDetector(
                            onTap: () => {
                                  HapticFeedback.mediumImpact(),
                                  url = '${link}grid_0_640_N.webp',
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              Favorite(context, link, index)))
                                },
                            child: SizedBox(
                                child: Stack(
                              children: <Widget>[
                                Hero(
                                  tag: '$link$index',
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: CachedNetworkImage(
                                        imageUrl: '${link}grid_0_640_N.webp',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 400,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )),
                                ),
                                Row(children: [
                                  _wallpaperUrlHome != 'Loading'
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            HapticFeedback.mediumImpact();
                                            if (_wallpaperUrlLock != 'Loading')
                                              setWallpaperHome(link);
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
                                            if (_wallpaperUrlHome != 'Loading')
                                              setWallpaperLock(link);
                                          },
                                          child: const Icon(
                                            Icons.screen_lock_landscape,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        )
                                      : const CircularProgressIndicator(),
                                ])
                              ],
                            ))),
                      ])));
                })
          ]),
        ));
  }
}
