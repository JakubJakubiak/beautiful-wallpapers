import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static void removeFromFavorites(String item, int indexImage) async {
    List<String> favorites = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getStringList('favorites') ?? []);

    List favoriteItems = favorites.map((f) => json.decode(f)).toList();

    int index = favoriteItems
        .indexWhere((f) => f['link'] == item && f['id'] == indexImage);
    if (index != -1) {
      favoriteItems.removeAt(index);

      favorites = favoriteItems.map((f) => json.encode(f)).toList();
      await SharedPreferences.getInstance()
          .then((prefs) => prefs.setStringList('favorites', favorites));
    }
  }
}
