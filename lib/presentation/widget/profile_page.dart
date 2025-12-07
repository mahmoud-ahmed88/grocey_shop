import 'package:flutter/material.dart';
// keep only the imports we actually use
import 'package:product_shop/presentation/pages/orders_page.dart';
// MyDetailsPage is used indirectly via MyDetailsViewPage; keep view import below
import 'package:product_shop/presentation/pages/my_details_view.dart';
// import 'package:product_shop/presentation/my_details_page.dart';

class ProfilePage extends StatefulWidget {
	static List<Map<String, dynamic>> orders = [];
	final String? name;
	final String? email;
	final String? password;
	final String? address;
	final String? phone;

	const ProfilePage({
		super.key,
		this.name,
		this.email,
		this.password,
		this.address,
		this.phone,
	});

	@override
	State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
	late String name;
	late String email;
	late String password;
	late String address;
	late String phone;

	@override
	void initState() {
		super.initState();
		name = widget.name ?? 'Account name';
		email = widget.email ?? 'email@gmail.com';
		password = widget.password ?? '';
		address = widget.address ?? '';
		phone = widget.phone ?? '';
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: Column(
				children: [
					const SizedBox(height: 50),

					// -------- Profile Header ---------
					Container(
						padding: const EdgeInsets.all(20),
						color: const Color(0xfffdeef2),
						child: Row(
							children: [
								const CircleAvatar(
									radius: 35,
									backgroundColor: Colors.grey,
									child: Icon(Icons.person, size: 40, color: Colors.white),
								),
								const SizedBox(width: 12),
								Expanded(
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
											const SizedBox(height: 4),
											Text(email, style: const TextStyle(color: Colors.grey)),
											const SizedBox(height: 8),

											Row(
												children: [
													ElevatedButton(
														onPressed: () async {
															// open read-only view and allow editing
															  final navigator = Navigator.of(context);
															  final messenger = ScaffoldMessenger.of(context);
															  final result = await navigator.push<Map<String, dynamic>>(
																MaterialPageRoute(
																	builder: (_) => MyDetailsViewPage(
																		name: name,
																		email: email,
																		password: password,
																		address: address,
																		phone: phone,
																	),
																),
															);

															if (!mounted) return;
															if (result != null) {
																setState(() {
																	name = (result['name'] as String?) ?? name;
																	email = (result['email'] as String?) ?? email;
																	password = (result['password'] as String?) ?? password;
																	address = (result['address'] as String?) ?? address;
																	phone = (result['phone'] as String?) ?? phone;
																});

																messenger.showSnackBar(const SnackBar(content: Text('update completed')));
															}
														},
														child: const Text('View details'),
													),
													const SizedBox(width: 8),
													OutlinedButton(
														onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrdersPage())),
														child: const Text('Orders'),
													),
												],
											),
										],
									),
								),
							],
						),
					),

					// -------- Profile Actions / Settings ---------
					Expanded(
						child: ListView(
							padding: const EdgeInsets.symmetric(vertical: 12),
							children: const [
								Divider(),
								ListTile(
									leading: Icon(Icons.location_on_outlined),
									title: Text("Delivery Address"),
									trailing: Icon(Icons.arrow_forward_ios, size: 18),
								),
								Divider(),
								ListTile(
									leading: Icon(Icons.credit_card_outlined),
									title: Text("Payment Methods"),
									trailing: Icon(Icons.arrow_forward_ios, size: 18),
								),
								Divider(),
								ListTile(
									leading: Icon(Icons.card_giftcard),
									title: Text("Promo Cards"),
									trailing: Icon(Icons.arrow_forward_ios, size: 18),
								),
								Divider(),
								ListTile(
									leading: Icon(Icons.notifications_none),
									title: Text("Notifications"),
									trailing: Icon(Icons.arrow_forward_ios, size: 18),
								),
								Divider(),
								ListTile(
									leading: Icon(Icons.help_outline),
									title: Text("Help"),
									trailing: Icon(Icons.arrow_forward_ios, size: 18),
								),
								Divider(),
								ListTile(
									leading: Icon(Icons.info_outline),
									title: Text("About"),
									trailing: Icon(Icons.arrow_forward_ios, size: 18),
								),
								Divider(),
							],
						),
					),
				],
			),
			// (Bottom navigation moved into AppShell)
		);
	}
}
