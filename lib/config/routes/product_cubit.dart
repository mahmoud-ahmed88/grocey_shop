import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_shop/model/product_model.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchProducts() async {
    try {
      emit(ProductLoading());
      final snapshot = await _firestore.collection('products').get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to fetch products: $e'));
    }
  }
}