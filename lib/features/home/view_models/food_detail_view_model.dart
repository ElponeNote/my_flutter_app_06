import 'package:flutter/material.dart';
import '../../cart/view_models/cart_provider.dart';
import '../views/widgets/food_recommendation_section.dart';

class FoodDetailViewModel extends ChangeNotifier {
  final FoodItem food;
  int _quantity = 1;

  // 옵션 관련
  final List<FoodOption> options = const [
    FoodOption(name: '곱빼기', price: 2000),
    FoodOption(name: '계란 추가', price: 1000),
    FoodOption(name: '치즈 추가', price: 1500),
  ];
  FoodOption? _selectedOption;

  FoodDetailViewModel({required this.food});

  int get quantity => _quantity;
  FoodOption? get selectedOption => _selectedOption;
  int get optionPrice => _selectedOption?.price ?? 0;
  int get total => (food.price + optionPrice) * _quantity;

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

  void selectOption(FoodOption? option) {
    _selectedOption = option;
    notifyListeners();
  }

  void addToCart(CartProvider cart, {String? memo}) {
    cart.addItem(food, quantity: _quantity, option: _selectedOption, memo: memo);
  }
} 