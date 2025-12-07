import 'package:product_shop/entity/product.dart';

abstract class DataRepository {
  Future<List<Product>> getAllProducts();

  /// Search via API (server-side / data layer)
  Future<List<Product>> searchProducts({required String query});

  /// Optional: get single product by id
  Future<Product?> getProductById({required int id});

  List<Product> topSold({required List<Product> products});

  List<Product> topViewed({required List<Product> products});
}
