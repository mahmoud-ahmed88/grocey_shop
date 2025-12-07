import 'package:flutter/material.dart';
import 'package:product_shop/presentation/pages/favourite_data.dart';


class FavouritePage extends StatefulWidget {
	const FavouritePage({super.key});

	@override
	State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text("Favourite")),

			body: ValueListenableBuilder<List<Map<String, dynamic>>>(
				valueListenable: FavouriteData.favouriteItems,
				builder: (context, favouriteItemsValue, _) {
					if (favouriteItemsValue.isEmpty) {
						return const Center(
							child: Text(
								"No favourites added yet",
								style: TextStyle(fontSize: 18),
							),
						);
					}

					return ListView.builder(
						itemCount: favouriteItemsValue.length,
						itemBuilder: (context, index) {
							final item = favouriteItemsValue[index];

							final price = (item['price'] as num?)?.toDouble() ?? 0.0;
							return ListTile(
								leading: item['image'] is String && (item['image'] as String).startsWith('http')
										? Image.network(item['image'], height: 45, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
										: Image.asset(item['image'], height: 45),
								title: Text(item['name'] ?? ''),
								subtitle: Text("${price.toStringAsFixed(2)} EGP"),
								trailing: IconButton(
									icon: const Icon(Icons.delete, color: Colors.red),
									onPressed: () {
										FavouriteData.removeAt(index);

										ScaffoldMessenger.of(context).showSnackBar(
											const SnackBar(
												content: Text("Removed from favourites"),
												backgroundColor: Colors.red,
											),
										);
									},
								),
							);
						},
					);
				},
			),
		);
	}
}
