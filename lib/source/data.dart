import 'dart:convert';
import 'package:product_shop/config/core/api/api.dart';
import 'package:product_shop/source/data_repository.dart';
import 'package:product_shop/model/product_model.dart';
import 'package:product_shop/entity/product.dart';
import 'package:product_shop/utils/pastebin dart api/usecases/show_paste.dart';

class Data extends DataRepository {
  @override
  Future<List<Product>> getAllProducts() async {
    const String response = '''
[
{
"id": 1,
"title": "Fresh Strawberries",
"description": "Sweet and juicy red strawberries, perfect for snacking, desserts, or smoothies.",
"category": "fruits",
"price": 4.99,
"image": "https://i.imgur.com/TYBIiTB.png",
"sold": 127,
"views": 1405
},
{
"id": 2,
"title": "Ripe Mangoes",
"description": "Tropical, sweet, and fibrous mangoes, excellent eaten fresh or in salads and salsas.",
"category": "fruits",
"price": 2.5,
"image": "https://i.imgur.com/NauJGHx.png",
"sold": 88,
"views": 312
},
{
"id": 3,
"title": "Crisp Red Apples",
"description": "Crunchy and slightly sweet apples, ideal for a healthy snack or baking.",
"category": "fruits",
"price": 3.99,
"image": "https://i.imgur.com/cXoqqUL.png",
"sold": 215,
"views": 1598
},
{
"id": 4,
"title": "Sweet Bananas",
"description": "Naturally sweet and creamy bananas, a great source of potassium and energy.",
"category": "fruits",
"price": 1.99,
"image": "https://i.imgur.com/6legbn7.png",
"sold": 134,
"views": 1887
},
{
"id": 5,
"title": "Seedless Grapes",
"description": "Bursting with sweetness, these green seedless grapes are a refreshing treat.",
"category": "fruits",
"price": 5.49,
"image": "https://i.imgur.com/b5lR0lx.png",
"sold": 94,
"views": 276
},
{
"id": 6,
"title": "Fresh Broccoli",
"description": "Nutrient-packed green broccoli, perfect for steaming, roasting, or adding to stir-fries.",
"category": "vegetables",
"price": 2.25,
"image": "https://i.imgur.com/vFgF7JQ.png",
"sold": 156,
"views": 421
},
{
"id": 7,
"title": "Organic Carrots",
"description": "Sweet and crunchy organic carrots, great raw as a snack or cooked in a variety of dishes.",
"category": "vegetables",
"price": 1.75,
"image": "https://i.imgur.com/kmJS2Ys.png",
"sold": 1203,
"views": 554
},
{
"id": 8,
"title": "Bell Peppers",
"description": "Colorful mix of red, yellow, and green bell peppers, adding crunch and flavor to any meal.",
"category": "vegetables",
"price": 3.99,
"image": "https://i.imgur.com/okkk0T1.png",
"sold": 118,
"views": 367
},
{
"id": 9,
"title": "Spinach Bunch",
"description": "Tender, dark leafy greens, excellent for salads, smoothies, or sautéing.",
"category": "vegetables",
"price": 2.99,
"image": "https://i.imgur.com/iY1WErx.png",
"sold": 178,
"views": 489
},
{
"id": 10,
"title": "Vine Tomatoes",
"description": "Juicy and flavorful tomatoes on the vine, perfect for salads, sandwiches, or sauces.",
"category": "vegetables",
"price": 3.49,
"image": "https://i.imgur.com/4TsXMfL.png",
"sold": 265,
"views": 1702
},
{
"id": 11,
"title": "Chicken Breast",
"description": "Lean and versatile boneless, skinless chicken breast, a high-protein staple for many meals.",
"category": "meats",
"price": 8.99,
"image": "https://i.imgur.com/TDSSBH4.png",
"sold": 331,
"views": 912
},
{
"id": 12,
"title": "Ground Beef",
"description": "Fresh 80/20 ground beef, ideal for burgers, meatballs, tacos, and pasta sauces.",
"category": "meats",
"price": 7.49,
"image": "https://i.imgur.com/Ell8sEt.png",
"sold": 287,
"views": 765
},
{
"id": 13,
"title": "Salmon Fillets",
"description": "Fresh, skin-on salmon fillets, rich in omega-3s and perfect for baking or grilling.",
"category": "meats",
"price": 12.99,
"image": "https://i.imgur.com/D4IsGyb.png",
"sold": 145,
"views": 1498
},
{
"id": 14,
"title": "Pork Chops",
"description": "Thick-cut bone-in pork chops, tender and juicy when grilled, baked, or pan-seared.",
"category": "meats",
"price": 9.99,
"image": "https://i.imgur.com/XTczdgs.png",
"sold": 0,
"views": 334
},
{
"id": 15,
"title": "Italian Sausages",
"description": "Flavorful pork sausages seasoned with fennel and other Italian herbs, great for grilling or pasta.",
"category": "meats",
"price": 6.99,
"image": "https://i.imgur.com/IRxk25o.png",
"sold": 19,
"views": 543
},
{
"id": 16,
"title": "Extra Virgin Olive Oil",
"description": "High-quality, cold-pressed olive oil, perfect for dressings, dipping, and finishing dishes.",
"category": "pantry",
"price": 10.99,
"image": "https://i.imgur.com/Rrj7kVj.png",
"sold": 221,
"views": 610
},
{
"id": 17,
"title": "Basmati Rice",
"description": "Long-grain, aromatic Basmati rice, known for its fluffy texture and delicate flavor.",
"category": "pantry",
"price": 4.49,
"image": "https://i.imgur.com/XqR1Ems.png",
"sold": 1305,
"views": 1801
},
{
"id": 18,
"title": "Sea Salt Grinder",
"description": "Coarse sea salt in a reusable grinder, for enhancing the flavor of all your dishes.",
"category": "pantry",
"price": 5.99,
"image": "https://i.imgur.com/5tT8KrU.png",
"sold": 134,
"views": 455
},
{
"id": 19,
"title": "Black Peppercorns",
"description": "Whole black peppercorns for grinding, offering robust and pungent flavor to your cooking.",
"category": "pantry",
"price": 3.99,
"image": "https://i.imgur.com/jf9em4k.png",
"sold": 187,
"views": 1522
},
{
"id": 20,
"title": "Balsamic Vinegar",
"description": "Aged, sweet and tangy balsamic vinegar, excellent for vinaigrettes and glazes.",
"category": "pantry",
"price": 7.5,
"image": "https://i.imgur.com/BRwJ7x3.png",
"sold": 96,
"views": 321
}
]
''';
    try {
      final List<Product> products = [];

      final List<dynamic> jsonList = jsonDecode(response) as List<dynamic>;

      for (final element in jsonList) {
        final map = Map<String, dynamic>.from(element as Map<String, dynamic>);
        // Map 'title' from your JSON to 'name' in the model.
        map['name'] = map['title'];
        products.add(ProductModel.fromJson(map));
      }

      return products;
    } catch (e) {
      // fallback lightweight list to keep UI functional
      // ignore: avoid_print
      print('Data.getAllProducts fallback due to exception: $e');
      return [];
    }
  }

  /// Search implementation: fetch the paste then filter by query (name, description).
  /// Doing the filtering in this layer makes the UI call the API for search (what you requested).
  @override
  Future<List<Product>> searchProducts({required String query}) async {
    try {
      final String response = await showPaste(pasteKey: Api.storeAPI);
      final List<dynamic> jsonList = jsonDecode(response) as List<dynamic>;
      final q = query.toLowerCase();

      final List<Product> results = [];
      for (final element in jsonList) {
        final map = element as Map<String, dynamic>;
        final name = (map['name'] as String?) ?? '';
        final desc = (map['description'] as String?) ?? '';
        final tags = (map['tags'] is List) ? (map['tags'] as List).join(' ') : '';

        if (name.toLowerCase().contains(q) ||
            desc.toLowerCase().contains(q) ||
            tags.toLowerCase().contains(q)) {
          results.add(ProductModel.fromJson(map));
        }
      }

      return results;
    } catch (e) {
      // On error return empty list (UI shows no results) and print for debug
      // ignore: avoid_print
      print('Data.searchProducts failed: $e');
      return <Product>[];
    }
  }

  @override
  Future<Product?> getProductById({required int id}) async {
    try {
      final String response = await showPaste(pasteKey: Api.storeAPI);
      final List<dynamic> jsonList = jsonDecode(response) as List<dynamic>;

      for (final element in jsonList) {
        final map = element as Map<String, dynamic>;
        if ((map['id'] is int && map['id'] == id) ||
            (map['id'] is String && int.tryParse(map['id']) == id)) {
          return ProductModel.fromJson(map);
        }
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Data.getProductById failed: $e');
      return null;
    }
  }

  @override
  List<Product> topSold({required List<Product> products}) {
    products.sort((a, b) => b.sold.compareTo(a.sold));
    return products;
  }

  @override
  List<Product> topViewed({required List<Product> products}) {
    products.sort((a, b) => b.views.compareTo(a.views));
    return products;
  }
}
