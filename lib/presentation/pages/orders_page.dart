import 'package:flutter/material.dart';
import 'package:product_shop/presentation/widget/profile_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  double _ordersTotal() {
    // Calculate total price of all orders
    return ProfilePage.orders.fold<double>(0.0, (sum, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final qty = (item['qty'] as int?) ?? 1;
      return sum + price * qty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ProfilePage.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet — checkout to create orders.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = orders[index];
                      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                      final qty = (item['qty'] as int?) ?? 1;

                      return ListTile(
                        leading: (item['image'] is String && (item['image'] as String).startsWith('http'))
                            ? Image.network(item['image'], width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
                            : Image.asset(item['image'], width: 56, height: 56, fit: BoxFit.cover),
                        title: Text(item['name'] ?? ''),
                        subtitle: Text('$qty × ${price.toStringAsFixed(2)} EGP'),
                        trailing: Text('${(price * qty).toStringAsFixed(2)} EGP', style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: ${_ordersTotal().toStringAsFixed(2)} EGP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ElevatedButton(
                        onPressed: () {
                          // allow clearing orders
                          showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Clear Orders'),
                              content: const Text('Remove all saved orders?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Clear')),
                              ],
                            ),
                          ).then((yes) {
                            if (yes == true) {
                              // setState is needed to rebuild the widget and show the empty state.
                                setState(() {
                                  ProfilePage.orders.clear();
                                });
                            }
                          });
                        },
                        child: const Text('Clear all'),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
