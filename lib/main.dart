import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      title: 'Human vs Ai',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Human vs Ai'),
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
// class _MyAppState extends State<MyApp> {
  int indexImage = 0;
  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';
  String url =
      'https://cdn.midjourney.com/59c8ad30-bde4-4828-96b1-0d81dec849a2/grid_0_640_N.webp';

  late bool goToHome;

  @override
  void initState() {
    super.initState();
    goToHome = false;
    initPlatformState();
  }

  Future<void> initPlatformState() async {}

  Future<void> setWallpaperHome(int index) async {
    setState(() {
      imageGalry(context, index);
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

  imageGalry(context, int index) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Hero(
                        tag: imageListLink[indexImage],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                              '${imageListLink[indexImage]}grid_0_640_N.webp',
                              width: MediaQuery.of(context).size.width,
                              height: 400,
                              fit: BoxFit.cover),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setWallpaperHome(index);
                        },
                        child: _wallpaperUrlHome == 'Loading'
                            ? const CircularProgressIndicator()
                            : const Text('Set wallpaper from Url home'),
                      ),
                      Center(
                        child: Text('Wallpaper status: $_wallpaperUrlHome\n'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setWallpaperLock(index);
                        },
                        child: _wallpaperUrlLock == 'Loading'
                            ? const CircularProgressIndicator()
                            : const Text('Set wallpaper from Url lock'),
                      ),
                      Center(
                        child: Text('Wallpaper status: $_wallpaperUrlLock\n'),
                      ),
                    ],
                  )),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: imageListLink.length,
        itemBuilder: (context, index) {
          indexImage = index;
          return Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
              child: Card(
                  child: Column(children: <Widget>[
                GestureDetector(
                    onTap: () => {
                          HapticFeedback.mediumImpact(),
                          indexImage = index,
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => imageGalry(
                                        context,
                                        index,
                                      )))
                        },
                    child: SizedBox(
                        child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: imageListLink[indexImage],
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                                '${imageListLink[indexImage]}grid_0_640_N.webp',
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                fit: BoxFit.cover),
                          ),
                        )
                      ],
                    ))),
              ])));
        });
  }
}
