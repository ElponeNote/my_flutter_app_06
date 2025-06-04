import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/cart_provider.dart';
import '../../home/views/food_detail_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.cart, size: 72, color: Colors.grey[300]),
                  SizedBox(height: 18),
                  Text('장바구니가 비어 있습니다', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 10),
                  Text('원하는 메뉴를 장바구니에 담아보세요!', style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                  SizedBox(height: 28),
                  SizedBox(
                    width: 180,
                    height: 44,
                    child: CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(12),
                      child: Text('홈으로 이동', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => SizedBox(height: 18),
              itemBuilder: (context, i) {
                final item = cart.items[i];
                return Dismissible(
                  key: ValueKey('${item.food.name}_${item.option?.name ?? ''}_${item.memo ?? ''}'),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 24),
                    color: Colors.red[100],
                    child: Icon(CupertinoIcons.delete, color: Colors.red, size: 32),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 24),
                    color: Colors.red[100],
                    child: Icon(CupertinoIcons.delete, color: Colors.red, size: 32),
                  ),
                  onDismissed: (_) {
                    cart.removeItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('장바구니에서 삭제되었습니다.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(food: item.food),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.food.imageUrl,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(food: item.food),
                            ),
                          );
                        },
                        child: Text(item.food.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text('${item.food.price}원', style: TextStyle(color: Color(0xFF5B5BFF))),
                          SizedBox(height: 8),
                          if (item.option != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text('옵션: ${item.option!.name} (+${item.option!.price}원)', style: TextStyle(fontSize: 13, color: Colors.black87)),
                            ),
                          if (item.memo != null && item.memo!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text('메모: ${item.memo}', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                            ),
                          Row(
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(28, 28),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    cart.updateQuantity(item, item.quantity - 1);
                                  }
                                },
                                child: Icon(CupertinoIcons.minus_circle, color: Colors.grey, size: 24),
                              ),
                              SizedBox(width: 6),
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 250),
                                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                child: Text(
                                  '${item.quantity}',
                                  key: ValueKey(item.quantity),
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(width: 6),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(28, 28),
                                onPressed: () {
                                  cart.updateQuantity(item, item.quantity + 1);
                                },
                                child: Icon(CupertinoIcons.plus_circle, color: Color(0xFF5B5BFF), size: 24),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('총 결제금액', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 250),
                          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                          child: Text(
                            '${cart.totalPrice}원',
                            key: ValueKey(cart.totalPrice),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B5BFF)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: CupertinoButton(
                        color: Color(0xFF5B5BFF),
                        borderRadius: BorderRadius.circular(12),
                        child: Text('결제하기', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green, size: 48),
                              content: Column(
                                children: [
                                  SizedBox(height: 16),
                                  Text('결제가 완료되었습니다!', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('맛있게 드세요 :)'),
                                ],
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    cart.clear();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 