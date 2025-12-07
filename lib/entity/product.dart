class Product<T> {
  final T id;
  final String name;
  final String image;
  final double price;
  final String? description;
  final int sold;
  final int views;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.sold,
    required this.views,
    this.description,
  });
}
