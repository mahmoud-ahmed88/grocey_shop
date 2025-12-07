import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_shop/model/product_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> placeOrder(List<ProductModel> items, double totalPrice) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final orderData = {
      'userId': user.uid,
      'items': items.map((p) => p.toFirestore()).toList(),
      'totalPrice': totalPrice,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('orders').add(orderData);
  }
}
