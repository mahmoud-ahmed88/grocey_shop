import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_shop/model/product_model.dart';
import './cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(ProductModel product) {
    final updatedItems = List<ProductModel>.from(state.items)..add(product);
    emit(state.copyWith(items: updatedItems));
  }

  void removeFromCart(ProductModel product) {
    final updatedItems = List<ProductModel>.from(state.items)..remove(product);
    emit(state.copyWith(items: updatedItems));
  }

  void clearCart() {
    emit(const CartState());
  }
}