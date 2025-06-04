import 'package:flutter/material.dart';
import '../../cart/view_models/cart_provider.dart';
import '../views/widgets/food_recommendation_section.dart';

class FoodDetailViewModel extends ChangeNotifier {
  final FoodItem food;
  int _quantity = 1;

  FoodDetailViewModel({required this.food});

  int get quantity => _quantity;
  int get total => food.price * _quantity;

  void increment() {
    _quantity++;
    notifyListeners();
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void addToCart(CartProvider cart) {
    cart.addItem(food, quantity: _quantity);
  }
} 