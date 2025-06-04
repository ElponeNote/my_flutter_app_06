import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../../home/views/widgets/food_recommendation_section.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(FoodItem food, {int quantity = 1, FoodOption? option, String? memo}) {
    final index = _items.indexWhere((item) =>
      item.food.name == food.name &&
      item.option?.name == option?.name &&
      (item.memo ?? '') == (memo ?? '')
    );
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(food: food, quantity: quantity, option: option, memo: memo));
    }
    notifyListeners();
  }

  void removeItem(CartItem target) {
    _items.remove(target);
    notifyListeners();
  }

  void updateQuantity(CartItem target, int quantity) {
    final index = _items.indexOf(target);
    if (index >= 0 && quantity > 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);
} 