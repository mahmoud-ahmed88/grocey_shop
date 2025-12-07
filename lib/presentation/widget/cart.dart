import 'package:flutter/material.dart';
import 'package:product_shop/config/routes/app_routes.dart';
import 'package:product_shop/presentation/widget/profile_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  // simple reactive shared in-memory cart used across the demo app
  static final ValueNotifier<List<Map<String, dynamic>>> cartItems = ValueNotifier([]);

  static void addItem(Map<String, dynamic> item) {
    final list = List<Map<String, dynamic>>.from(cartItems.value);
    list.add(item);
    cartItems.value = list;
  }

  static void removeAtIndex(int i) {
    final list = List<Map<String, dynamic>>.from(cartItems.value);
    if (i >= 0 && i < list.length) {
      list.removeAt(i);
      cartItems.value = list;
    }
  }

  static void updateQtyAt(int i, int qty) {
    final list = List<Map<String, dynamic>>.from(cartItems.value);
    if (i >= 0 && i < list.length) {
      list[i] = Map.of(list[i])..['qty'] = qty;
      cartItems.value = list;
    }
  }

  static void clearAll() {
    cartItems.value = [];
  }

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We'll listen to cartItems and rebuild when it changes
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: CartPage.cartItems,
      builder: (context, cartItemsValue, _) {
        // filtered view of the cart based on the search query
        final displayItems = _searchQuery.isEmpty
            ? cartItemsValue
            : cartItemsValue.where((item) {
                final name = (item['name'] ?? '').toString().toLowerCase();
                final price = (item['price'] ?? '').toString().toLowerCase();
                final q = _searchQuery.toLowerCase();
                return name.contains(q) || price.contains(q);
              }).toList();

        double totalForDisplayed() {
          return displayItems.fold<double>(0.0, (sum, item) {
            final p = (item['price'] as num?)?.toDouble() ?? 0.0;
            final q = (item['qty'] as int?) ?? 1;
            return sum + p * q;
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Cart',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
              },
            ),
          ),
          body: cartItemsValue.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty 🛒',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search in cart... (name or price)',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _searchQuery = ''; // reset filter
                                          });
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (v) => setState(() => _searchQuery = v.trim()),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // show filtered / total counts
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${displayItems.length}/${cartItemsValue.length}'),
                          ),
                        ],
                      ),
                    ),

                    // results
                    Expanded(
                      child: displayItems.isEmpty
                          ? const Center(child: Text('No items match your search.'))
                          : ListView.builder(
                              itemCount: displayItems.length,
                              itemBuilder: (context, index) {
                                final item = displayItems[index];
                                // operate on the original list so changes persist
                                final originalIndex = cartItemsValue.indexOf(item);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // image
                                      (item['image'] is String &&
                                              (item['image'] as String).startsWith('http'))
                                          ? Image.network(
                                              item['image'],
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                            )
                                          : Image.asset(
                                              item['image'],
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item['name'] ?? '',
                                                style: const TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text('${(item['qty'] as int?) ?? 1} item(s)',
                                                style: const TextStyle(color: Colors.grey)),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        children: [
                                          // remove
                                          IconButton(
                                            icon: const Icon(Icons.close, color: Colors.grey),
                                            onPressed: () {
                                              CartPage.removeAtIndex(originalIndex);
                                            },
                                          ),

                                          // qty controls
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove_circle_outline,
                                                    color: Colors.grey),
                                                onPressed: () {
                                                  final q = (item['qty'] as int?) ?? 1;
                                                  if (q > 1) {
                                                    CartPage.updateQtyAt(originalIndex, q - 1);
                                                  } else {
                                                    CartPage.removeAtIndex(originalIndex);
                                                  }
                                                },
                                              ),
                                              Text(
                                                  "${(item['qty'] as int?) ?? 1}",
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 16)),
                                              IconButton(
                                                icon: const Icon(Icons.add_circle_outline,
                                                    color: Colors.grey),
                                                onPressed: () {
                                                  final q = (item['qty'] as int?) ?? 1;
                                                  CartPage.updateQtyAt(originalIndex, q + 1);
                                                },
                                              ),
                                            ],
                                          ),

                                          Text(
                                            '\$${(((item['price'] as num?) ?? 0) * ((item['qty'] as int?) ?? 1)).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),

          // -----------------------------------
          // BOTTOM CHECKOUT
          // -----------------------------------

          bottomNavigationBar: cartItemsValue.isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // if filtered, checkout only displayed items; otherwise checkout whole cart
                      final itemsToCheckout =
                          _searchQuery.isEmpty ? List.of(cartItemsValue) : List.of(displayItems);

                      ProfilePage.orders.addAll(itemsToCheckout);

                      if (_searchQuery.isEmpty) {
                        CartPage.clearAll();
                      } else {
                        // remove matching items from the cart
                        final remaining = List.of(cartItemsValue)
                          ..removeWhere((e) => itemsToCheckout.contains(e));
                        CartPage.cartItems.value = remaining;
                      }

                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Checkout',
                            style: TextStyle(color: Colors.white, fontSize: 18)),
                        const SizedBox(width: 10),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            '${totalForDisplayed().toStringAsFixed(2)} EGP',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
