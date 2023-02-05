import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:beautifulwallpapers/script/allscripts.dart';

class Utils {
  static void removeFromFavorites(String link) async {
    List<String> favorites = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getStringList('favorites') ?? []);

    List favoriteItems = favorites.map((f) => json.decode(f)).toList();

    int index = favoriteItems.indexWhere((f) => f['link'] == link);
    if (index != -1) {
      favoriteItems.removeAt(index);

      favorites = favoriteItems.map((f) => json.encode(f)).toList();
      await SharedPreferences.getInstance()
          .then((prefs) => prefs.setStringList('favorites', favorites));
    }
  }
}
