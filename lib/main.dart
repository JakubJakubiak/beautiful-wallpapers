import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './image/imageListLink.dart';

void main() async {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int indexImage = 0;
  String _platformVersion = 'Unknown';
  String _wallpaperFileNative = 'Unknown';
  String _wallpaperFileHome = 'Unknown';
  String _wallpaperFileLock = 'Unknown';
  String _wallpaperFileBoth = 'Unknown';
  String _wallpaperUrlNative = 'Unknown';
  String _wallpaperUrlHome = 'Unknown';
  String _wallpaperUrlLock = 'Unknown';
  String _wallpaperUrlBoth = 'Unknown';
  String _liveWallpaper = 'Unknown';
  String url =
      'https://cdn.midjourney.com/59c8ad30-bde4-4828-96b1-0d81dec849a2/grid_0_640_N.webp';
  String liveUrl =
      'https://github.com/codenameakshay/sample-data/raw/main/video3.mp4';

  late bool goToHome;

  @override
  void initState() {
    super.initState();
    goToHome = false;
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await AsyncWallpaper.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperFromFileNative() async {
    setState(() {
      _wallpaperFileNative = 'Loading';
    });
    String result;
    var file = await DefaultCacheManager().getSingleFile(url);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaperFromFileNative(
        filePath: file.path,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperFileNative = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperFromFileHome() async {
    setState(() {
      _wallpaperFileHome = 'Loading';
    });
    String result;
    var file = await DefaultCacheManager().getSingleFile(url);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaperFromFile(
        filePath: file.path,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperFileHome = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperFromFileLock() async {
    setState(() {
      _wallpaperFileLock = 'Loading';
    });
    String result;
    var file = await DefaultCacheManager().getSingleFile(url);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaperFromFile(
        filePath: file.path,
        wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperFileLock = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperFromFileBoth() async {
    setState(() {
      _wallpaperFileBoth = 'Loading';
    });
    String result;
    var file = await DefaultCacheManager().getSingleFile(url);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaperFromFile(
        filePath: file.path,
        wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperFileBoth = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperNative() async {
    setState(() {
      _wallpaperUrlNative = 'Loading';
    });
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaperNative(
        url: url,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperUrlNative = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperHome(int index) async {
    setState(() {
      indexImage = index;
      url = imageListLink[indexImage];
      _wallpaperUrlHome = 'Loading';
    });
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperUrlHome = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperLock() async {
    setState(() {
      _wallpaperUrlLock = 'Loading';
    });
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperUrlLock = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setWallpaperBoth() async {
    setState(() {
      _wallpaperUrlBoth = 'Loading';
    });
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _wallpaperUrlBoth = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setLiveWallpaper() async {
    setState(() {
      _liveWallpaper = 'Loading';
    });
    String result;
    var file = await DefaultCacheManager().getSingleFile(liveUrl);
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await AsyncWallpaper.setLiveWallpaper(
        filePath: file.path,
        goToHome: goToHome,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _liveWallpaper = result;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            child: Image.network(imageListLink[index],
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
                          onPressed: setWallpaperLock,
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
                          _wallpaperUrlHome = 'Unknown',
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => imageGalry(
                                        context,
                                        index,
                                      )))
                        },
                    child: SizedBox(
                        // height: 200,
                        child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: imageListLink[indexImage],
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(imageListLink[indexImage],
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
