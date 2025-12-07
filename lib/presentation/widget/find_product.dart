import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_shop/config/routes/app_routes.dart';

class ExplorePage extends StatelessWidget {
	ExplorePage({super.key});

	final List<Map<String, dynamic>> categories = [
		{
			"name": "Fresh Fruits & Vegetable",
			"image": "assets/images/fruits.png",
			"color": const Color(0xffE2F4E8),
			"border": Colors.green
		},
		{
			"name": "Cooking Oil & Ghee",
			"image": "assets/images/oil.png",
			"color": const Color(0xffFDECEC),
			"border": Colors.red
		},
		{
			"name": "Meat & Fish",
			"image": "assets/images/meat.png",
			"color": const Color(0xffF4ECF7),
			"border": Colors.purple
		},
		{
			"name": "Bakery & Snacks",
			"image": "assets/images/bakery.png",
			"color": const Color(0xffEDEAFF),
			"border": Colors.deepPurple
		},
		{
			"name": "Dairy & Eggs",
			"image": "assets/images/eggs.png",
			"color": const Color(0xffFFF3E8),
			"border": Colors.orange
		},
		{
			"name": "Beverages",
			"image": "assets/images/beverages.png",
			"color": const Color(0xffE8F5FF),
			"border": Colors.blue
		},
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: const Color(0xffFFF7FB),

			/// -------------------- APP BAR --------------------
			appBar: AppBar(
				backgroundColor: Colors.white,
				elevation: 2,
				centerTitle: true,
				leading: IconButton(
					icon: const Icon(Icons.arrow_back, color: Colors.black87),
					onPressed: () {
						Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
					},
				),
				systemOverlayStyle: SystemUiOverlayStyle.dark,
				title: const Text(
					"Find Products",
					style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
				),
			),

			/// -------------------- BODY --------------------
			body: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 16),
				child: Column(
					children: [
						/// ---------- Search Bar ----------
						Container(
							padding: const EdgeInsets.symmetric(horizontal: 16),
							height: 50,
							decoration: BoxDecoration(
								color: const Color(0xffF2F3F2),
								borderRadius: BorderRadius.circular(14),
							),
							child: const Row(
								children: [
									Icon(Icons.search, color: Colors.black54),
									SizedBox(width: 10),
									Expanded(
										child: Text(
											"Search Store",
											style: TextStyle(color: Colors.black45, fontSize: 16),
										),
									)
								],
							),
						),

						const SizedBox(height: 20),

						/// ---------- Grid View ----------
						Expanded(
							child: GridView.builder(
								itemCount: categories.length,
								gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
										crossAxisCount: 2,
										mainAxisSpacing: 15,
										crossAxisSpacing: 15,
										childAspectRatio: 0.90),
								itemBuilder: (context, index) {
									final item = categories[index];

									return Container(
										decoration: BoxDecoration(
											color: item["color"],
											borderRadius: BorderRadius.circular(18),
											border: Border.all(color: item["border"], width: 1.2),
										),
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												Image.asset(item["image"], height: 80),
												const SizedBox(height: 10),
												Text(
													item["name"],
													textAlign: TextAlign.center,
													style: const TextStyle(
														fontSize: 15,
														fontWeight: FontWeight.w600,
													),
												)
											],
										),
									);
								},
							),
						),
					],
				),
			),

			// Explore page uses the app bar from Home for navigation — no bottom bar here.
		);
	}
}
