// simple reactive storage for favourite items used across the demo app
import 'package:flutter/foundation.dart';

class FavouriteData {
  // ValueNotifier so UI can listen and update when favourites change
  static final ValueNotifier<List<Map<String, dynamic>>> favouriteItems = ValueNotifier([]);

  static void add(Map<String, dynamic> item) {
    final list = List<Map<String, dynamic>>.from(favouriteItems.value);
    list.add(item);
    favouriteItems.value = list;
  }

  static void removeWhere(bool Function(Map<String, dynamic>) test) {
    final list = List<Map<String, dynamic>>.from(favouriteItems.value);
    list.removeWhere(test);
    favouriteItems.value = list;
  }

  static void removeAt(int index) {
    final list = List.of(favouriteItems.value);
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      favouriteItems.value = list;
    }
  }
}
