import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './image/imageListLink.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      checkerboardRasterCacheImages: true,
      title: 'Beautiful Wallpapers',
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      home: const MyHomePage(title: 'Beautiful Wallpapers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int indexImage = 0;
  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';
  String url = '';

  late bool goToHome;
  late SharedPreferences prefs;
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    goToHome = false;
    initPlatformState();
    _getFavorites();
  }

  Future<void> initPlatformState() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _addToFavorites(String item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList('favorites') ?? [];
    items.add(item);
    prefs.setStringList('favorites', items);

    setState(() {
      _favorites = Set<String>.from(_favorites..add(item)).toList();
    });
  }

  Future<void> _getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList('favorites') ?? [];

    setState(() {
      _favorites = items;
    });
  }

  void removeFromFavorites(String item) async {
    setState(() {
      _favorites.remove(item);
    });
  }

  @override
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

  imageGalry(context, index) {
    String action;

    prefs.getStringList('items');
    final List<String>? itemsList = prefs.getStringList('items');
    print(itemsList);

    return Scaffold(
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
                    Column(verticalDirection: VerticalDirection.up, children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 50.0,
                          left: 50.0,
                        ),
                      ),
                      Text('$prefs'),
                      Row(children: [
                        _wallpaperUrlLock != 'Loading'
                            ? ElevatedButton(
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  setWallpaperHome(index);
                                },
                                child: const Icon(
                                  Icons.fit_screen,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 40,
                                ),
                              )
                            : const CircularProgressIndicator(),
                        _wallpaperUrlLock != 'Loading'
                            ? ElevatedButton(
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  setWallpaperLock(index);
                                },
                                child: const Icon(
                                  Icons.screen_lock_landscape,
                                  color: Color.fromARGB(255, 255, 255, 255),
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
                                  color: Color.fromARGB(255, 217, 17, 17),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  HapticFeedback.mediumImpact();
                                  _addToFavorites(imageListLink[indexImage]);
                                },
                                child: const Icon(
                                  Icons.favorite_border,
                                  size: 40,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                      ])
                    ])
                  ],
                )),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: imageListLink.length,
        itemBuilder: (context, index) {
          indexImage = index;
          return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Card(
                  child: Column(children: <Widget>[
                GestureDetector(
                    onTap: () => {
                          HapticFeedback.mediumImpact(),
                          indexImage = index,
                          url = '${imageListLink[indexImage]}grid_0_640_N.webp',
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      imageGalry(context, index)))
                        },
                    child: SizedBox(
                        child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: imageListLink[indexImage],
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${imageListLink[indexImage]}grid_0_640_N.webp',
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                        ),
                        Row(children: [
                          _wallpaperUrlHome != 'Loading' && indexImage == index
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
                                  child:
                                      const Icon(Icons.screen_lock_landscape),
                                )
                              : const CircularProgressIndicator(),
                        ])
                      ],
                    ))),
              ])));
        });
  }
}
