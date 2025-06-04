import '../../home/views/widgets/food_recommendation_section.dart';

class CartItem {
  final FoodItem food;
  int quantity;
  final FoodOption? option;
  final String? memo;

  CartItem({
    required this.food,
    this.quantity = 1,
    this.option,
    this.memo,
  });

  int get totalPrice => (food.price + (option?.price ?? 0)) * quantity;
} 