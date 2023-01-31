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

export 'package:beautifulwallpapers/script/favorite.dart';

class Favorite extends StatefulWidget {
  final BuildContext context;
  final int indexImage;

// _ChooseLocationState({this.indexImage});
  // const Favorite(BuildContext context, int indexImage, {super.key});
  Favorite(
    this.context,
    this.indexImage,
  ) : super(key: UniqueKey());

  @override
  createState() => _ChooseLocationState(indexImage: indexImage);
}

class _ChooseLocationState extends State<Favorite> {
  List<String> _favorites = [];

  int indexImage = 0;
  _ChooseLocationState({required this.indexImage});
  String url = '';

  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';

  late bool goToHome;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    goToHome = false;
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
      // _favorites = Set<String>.from(_favorites..add(item)).toList();
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
        // HomePageBackground(
        //   screenHeight: MediaQuery.of(context).size.height,
        // ),
        // imageGalry(context, int indexImage) {
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
                                  _favorites.any((element) =>
                                          element == imageListLink[indexImage])
                                      ? GestureDetector(
                                          onTap: () async {
                                            HapticFeedback.mediumImpact();
                                            removeFromFavorites(
                                                imageListLink[indexImage]);
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
                                            await _addToFavorites(
                                                imageListLink[indexImage]);
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
