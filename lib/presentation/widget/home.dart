
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:product_shop/config/routes/app_routes.dart';
import 'package:product_shop/presentation/widget/details.dart';
import 'package:product_shop/presentation/pages/favourite_data.dart';
import 'package:product_shop/source/data.dart';
import 'package:product_shop/source/data_repository.dart';
import 'package:product_shop/entity/product.dart';

class HomePage extends StatefulWidget {
	const HomePage({super.key});

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	int currentIndex = 0;

	final DataRepository dataRepo = Data();
	Future<List<Product>>? futureProducts;
	final TextEditingController _searchController = TextEditingController();
	String _searchQuery = '';
	final ScrollController _scrollController = ScrollController();

	Timer? _debounce;

	@override
	void initState() {
		super.initState();
		// initially load all products from API
		futureProducts = dataRepo.getAllProducts();

		_searchController.addListener(() {
			final q = _searchController.text.trim();
			if (_searchQuery == q) return;
			_searchQuery = q;
			_onSearchQueryChanged(q);
		});

		// listen to favourite changes to rebuild the UI (heart icons)
		FavouriteData.favouriteItems.addListener(() {
			if (mounted) setState(() {});
		});
	}

	void _onSearchQueryChanged(String query) {
		// debounce to avoid firing API on every keystroke
		_debounce?.cancel();
		_debounce = Timer(const Duration(milliseconds: 500), () {
			setState(() {
				if (query.isEmpty) {
					futureProducts = dataRepo.getAllProducts();
				} else {
					futureProducts = dataRepo.searchProducts(query: query);
				}
			});
		});
	}

	@override
	void dispose() {
		_searchController.dispose();
		_scrollController.dispose();
		_debounce?.cancel();
		super.dispose();
	}

	bool isFavourite(Product item) {
		return FavouriteData.favouriteItems.value.any((fav) => fav['name'] == item.name);
	}

	@override
	Widget build(BuildContext context) {
		final args =
				ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

		final String userName = args?['name'] ?? 'Guest User';
		final String userEmail = args?['email'] ?? 'guest@example.com';
		final String userPass = args?['password'] ?? 'unknown';
		final String userAddress = args?['address'] ?? '';
		final String userPhone = args?['phone'] ?? '';

		return Scaffold(
			appBar: AppBar(
				title: const Text('E-Grocery'),
			),

			body: Column(
				children: [
					Expanded(
						child: ListView(
							controller: _scrollController,
							children: [
								// Banner
								Container(
									height: 180,
									decoration: BoxDecoration(
										image: const DecorationImage(
											image: AssetImage('assets/images/food_banner.png'),
											fit: BoxFit.cover,
										),
										borderRadius: BorderRadius.circular(20),
									),
									margin: const EdgeInsets.all(10),
									child: Stack(
										children: [
											Positioned(
												left: 15,
												bottom: 20,
												child: Text(
													'Welcome $userName!',
													style: const TextStyle(
															color: Colors.white,
															fontSize: 22,
															fontWeight: FontWeight.bold),
												),
											),
											Positioned(
												right: 12,
												top: 12,
														child: GestureDetector(
													onTap: () {
														Navigator.pushNamed(
															context,
															AppRoutes.profile,
															arguments: {
																'name': userName,
																'email': userEmail,
																'password': userPass,
																'address': userAddress,
																'phone': userPhone,
															},
														);
													},
													child: const CircleAvatar(
														radius: 26,
														backgroundImage:
																AssetImage('assets/images/profile.png'),
													),
												),
											),
										],
									),
								),

								// Search
								Padding(
									padding: const EdgeInsets.all(8.0),
									child: TextField(
										controller: _searchController,
										decoration: InputDecoration(
											prefixIcon: const Icon(Icons.search),
											hintText: 'Search products...',
											border: OutlineInputBorder(
													borderRadius: BorderRadius.circular(12)),
											suffixIcon: _searchQuery.isNotEmpty
													? IconButton(
															icon: const Icon(Icons.clear),
															onPressed: () {
																_searchController.clear();
																// clearing will trigger listener and reload all products after debounce
															},
														)
													: null,
										),
									),
								),

								// Title
								Padding(
									padding:
											const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											const Text("Groceries",
													style: TextStyle(
															fontSize: 22, fontWeight: FontWeight.bold)),
											TextButton(
												onPressed: () {
													_scrollController.animateTo(
														_scrollController.position.maxScrollExtent,
														duration: const Duration(seconds: 1),
														curve: Curves.easeInOut,
													);
												},
												child: const Text(
													"See all",
													style: TextStyle(color: Colors.green, fontSize: 16),
												),
											),
										],
									),
								),

								// Products from API
								FutureBuilder<List<Product>>(
									future: futureProducts,
									builder: (context, snapshot) {
										if (snapshot.connectionState == ConnectionState.waiting) {
											return const Center(
												child: Padding(
													padding: EdgeInsets.all(20.0),
													child: CircularProgressIndicator(),
												),
											);
										}

										if (snapshot.hasError) {
											return Padding(
												padding: const EdgeInsets.all(20.0),
												child: Column(
													children: [
														Text("Error loading products: ${snapshot.error}"),
														const SizedBox(height: 10),
														ElevatedButton(
															onPressed: () {
																setState(() {
																	futureProducts = dataRepo.getAllProducts();
																});
															},
															child: const Text('Retry'),
														)
													],
												),
											);
										}

										final products = snapshot.data ?? <Product>[];

										final displayList = products;
										if (displayList.isEmpty) {
											return const Padding(
												padding: EdgeInsets.all(20.0),
												child: Center(child: Text('No products match your search')),
											);
										}

										// Use a grid for product cards: 2 columns, scroll handled by outer ListView
										return Padding(
											padding: const EdgeInsets.symmetric(horizontal: 10.0),
											child: GridView.builder(
												shrinkWrap: true,
												physics: const NeverScrollableScrollPhysics(),
												gridDelegate:
														const SliverGridDelegateWithFixedCrossAxisCount(
													crossAxisCount: 2,
													crossAxisSpacing: 12,
													mainAxisSpacing: 12,
													childAspectRatio: 0.72,
												),
												itemCount: displayList.length,
												itemBuilder: (context, index) {
													final item = displayList[index];

													return Container(
														margin: const EdgeInsets.only(right: 12),
														decoration: BoxDecoration(
															color: Colors.white,
															borderRadius: BorderRadius.circular(20),
															boxShadow: [
																BoxShadow(
																	color:
																			const Color.fromRGBO(0, 0, 0, 0.1),
																	blurRadius: 6,
																	offset: const Offset(1, 3),
																),
															],
														),
														child: Column(
															children: [
																const SizedBox(height: 10),

																GestureDetector(
																	onTap: () {
																		Navigator.push(
																			context,
																			MaterialPageRoute(
																				builder: (_) =>
																						DetailsPage(product: item),
																			),
																		);
																	},
																	child: SizedBox(
																		height: 150,
																		child: Center(
																			child: item.image.startsWith('http')
																					? ClipRRect(
																							borderRadius:
																									BorderRadius.circular(12),
																							child: Image.network(
																								item.image,
																								height: 140,
																								width: double.infinity,
																								fit: BoxFit.cover,
																								errorBuilder: (_, __, ___) => const Icon(
																										Icons.broken_image,
																										size: 80),
																							),
																						)
																					: ClipRRect(
																							borderRadius:
																									BorderRadius.circular(12),
																							child: Image.asset(
																								item.image,
																								height: 140,
																								width: double.infinity,
																								fit: BoxFit.cover,
																							),
																						),
																		),
																	),
																),

																const SizedBox(height: 10),

																Text(
																	item.name,
																	textAlign: TextAlign.center,
																	style: const TextStyle(
																			fontSize: 16,
																			fontWeight: FontWeight.bold),
																),

																const Text(
																	"1kg, Price",
																	style: TextStyle(
																			color: Colors.grey, fontSize: 13),
																),

																const SizedBox(height: 10),

																Padding(
																	padding:
																			const EdgeInsets.symmetric(horizontal: 12),
																	child: Row(
																		mainAxisAlignment:
																				MainAxisAlignment.spaceBetween,
																		children: [
																			Text(
																				"\$${item.price}",
																				style: const TextStyle(
																						fontWeight: FontWeight.bold,
																						fontSize: 17),
																			),

																			// ❤️ Favourite Button
																			GestureDetector(
																																								onTap: () {
																																									if (isFavourite(item)) {
																																										FavouriteData.removeWhere((fav) => fav['name'] == item.name);

																																										ScaffoldMessenger.of(context).showSnackBar(
																																											const SnackBar(
																																												content: Text("Removed from favorites"),
																																												backgroundColor: Colors.red,
																																											),
																																										);
																																									} else {
																																										FavouriteData.add({
																																											'name': item.name,
																																											'image': item.image,
																																											'price': item.price,
																																										});

																																										ScaffoldMessenger.of(context).showSnackBar(
																																											const SnackBar(
																																												content: Text("Added to favorites successfully"),
																																												backgroundColor: Colors.green,
																																											),
																																										);
																																									}
																																								},
																				child: Icon(
																					isFavourite(item)
																							? Icons.favorite
																							: Icons.favorite_border,
																					color: isFavourite(item)
																							? Colors.red
																							: Colors.grey,
																					size: 28,
																				),
																			),
																		],
																	),
																),
															],
														),
													);
												},
											),
										);
									},
								),

								const SizedBox(height: 10),
							],
						),
					),
				],
			),

			// (Bottom navigation moved to AppShell)
		);
	}
}
