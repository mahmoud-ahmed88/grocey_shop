import 'package:flutter/material.dart';
import 'package:product_shop/config/routes/app_routes.dart';
import 'package:product_shop/entity/product.dart';
import 'package:product_shop/presentation/pages/favourite_data.dart';
import 'package:product_shop/presentation/widget/cart.dart';

class DetailsPage extends StatefulWidget {
	final Product product; // use the abstract Product type

	const DetailsPage({super.key, required this.product});

	@override
	State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
	int _qty = 1;

	bool get _isFavourite => FavouriteData.favouriteItems.value.any((fav) => fav['name'] == widget.product.name); // check if item is in favs

	void _toggleFavourite() {
		if (_isFavourite) {
			FavouriteData.removeWhere((fav) => fav['name'] == widget.product.name);
		} else {
			FavouriteData.add({
				'name': widget.product.name, // use widget.product
				'image': widget.product.image, // use widget.product
				'price': widget.product.price, // use widget.product
			});
		}
		setState(() {}); // rebuild to update heart icon
	}

	void _addToCart() {
		final product = widget.product;
		final existing = CartPage.cartItems.value.indexWhere((e) => e['name'] == product.name);

		if (existing >= 0) { // if item exists, update its quantity
			final currentQty = (CartPage.cartItems.value[existing]['qty'] as int?) ?? 1;
			CartPage.updateQtyAt(existing, currentQty + _qty);
		} else {
			// otherwise, add it as a new item
			CartPage.addItem({
				'name': product.name,
				'image': product.image,
				'price': product.price,
				'qty': _qty,
			});
		}

		// show confirmation message
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(
				content: Text("${product.name} (x$_qty) added to cart!"),
				duration: const Duration(seconds: 2),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.product.name, style: const TextStyle(color: Colors.white)),
				backgroundColor: Colors.green,
				leading: IconButton(
					icon: const Icon(Icons.arrow_back, color: Colors.white),
					onPressed: () {
						Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
					},
				),
				actions: [
					IconButton(
						icon: const Icon(Icons.shopping_cart, color: Colors.white),
						onPressed: () {
							Navigator.pushNamed(context, AppRoutes.cart);
						},
					),
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(20),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						Center(
							child: widget.product.image.startsWith('http')
									? Image.network(
											widget.product.image,
											height: 200,
											errorBuilder: (context, error, stack) => const Icon(Icons.error, size: 100),
										)
									: Image.asset(
											widget.product.image,
											height: 200,
										),
						),
						const SizedBox(height: 20),
						Text(
							widget.product.name,
							style: TextStyle(
								fontSize: 24,
								fontWeight: FontWeight.bold,
								color: Colors.green[700],
							),
						),
						const SizedBox(height: 10),
						Text(
							"${widget.product.price.toStringAsFixed(2)} EGP",
							style: const TextStyle(fontSize: 20, color: Colors.black54),
						),
						const SizedBox(height: 10),
						Text(
							widget.product.description ?? 'Delicious and fresh food to satisfy your hunger.',
							textAlign: TextAlign.center,
							style: const TextStyle(fontSize: 16, color: Colors.grey),
						),
												const SizedBox(height: 10),

												// quantity selector + favourite button
												Row(
													mainAxisAlignment: MainAxisAlignment.center,
													children: [
														IconButton(
															icon: const Icon(Icons.remove_circle_outline),
															onPressed: () {
																if (_qty > 1) setState(() => _qty--);
															},
														),

														Container(
															padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
															decoration: BoxDecoration(
																color: Colors.grey.shade200,
																borderRadius: BorderRadius.circular(8),
															),
															child: Text('$_qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
														),

														IconButton(
															icon: const Icon(Icons.add_circle_outline),
															onPressed: () => setState(() => _qty++),
														),

														const SizedBox(width: 16),

														IconButton(
															icon: Icon(_isFavourite ? Icons.favorite : Icons.favorite_border, color: _isFavourite ? Colors.red : Colors.grey),
															onPressed: _toggleFavourite,
															iconSize: 28,
														),
													],
												),

												const SizedBox(height: 10),

												ElevatedButton.icon(
													onPressed: _addToCart,
													style: ElevatedButton.styleFrom(
														backgroundColor: Colors.green,
														padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
														shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
													),
													icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
													label: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 18)), // Add to Cart button
												),
												const SizedBox(height: 20),
					],
				),
			),
		);
	}
}
