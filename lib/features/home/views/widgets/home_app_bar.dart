import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../cart/view_models/cart_provider.dart';
import '../../../cart/views/cart_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().items.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "FOODIGO",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF5B5BFF), // 브랜드 컬러
                  ),
                ),
                TextSpan(text: " "),
                WidgetSpan(
                  child: Icon(CupertinoIcons.star, size: 22, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Spacer(),
          Icon(CupertinoIcons.search, size: 26, color: Colors.grey[700]),
          SizedBox(width: 18),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.cart, size: 26, color: Colors.grey[700]),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFF5B5BFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$cartCount',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
} 