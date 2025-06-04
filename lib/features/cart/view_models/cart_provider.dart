import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../../home/views/widgets/food_recommendation_section.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(FoodItem food, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.food.name == food.name);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(food: food, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(FoodItem food) {
    _items.removeWhere((item) => item.food.name == food.name);
    notifyListeners();
  }

  void updateQuantity(FoodItem food, int quantity) {
    final index = _items.indexWhere((item) => item.food.name == food.name);
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