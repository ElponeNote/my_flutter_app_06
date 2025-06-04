import '../../home/views/widgets/food_recommendation_section.dart';

class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});

  int get totalPrice => food.price * quantity;
} 