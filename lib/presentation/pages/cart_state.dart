import 'package:flutter/material.dart';
import 'package:product_shop/model/product_model.dart';

@immutable
class CartState {
  final List<ProductModel> items;

  const CartState({this.items = const []});

  double get totalPrice => items.fold(0, (total, current) => total + current.price);

  CartState copyWith({List<ProductModel>? items}) {
    return CartState(
      items: items ?? this.items,
    );
  }
}