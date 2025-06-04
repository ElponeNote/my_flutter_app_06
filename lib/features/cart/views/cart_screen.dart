import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/cart_provider.dart';

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
          ? Center(child: Text('장바구니가 비어 있습니다.', style: TextStyle(fontSize: 18)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => SizedBox(height: 18),
              itemBuilder: (context, i) {
                final item = cart.items[i];
                return Container(
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
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.food.imageUrl,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.food.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('${item.food.price}원', style: TextStyle(color: Color(0xFF5B5BFF))),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 28,
                              onPressed: () {
                                if (item.quantity > 1) {
                                  cart.updateQuantity(item.food, item.quantity - 1);
                                }
                              },
                              child: Icon(CupertinoIcons.minus_circle, color: Colors.grey, size: 24),
                            ),
                            SizedBox(width: 6),
                            Text('${item.quantity}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 28,
                              onPressed: () {
                                cart.updateQuantity(item.food, item.quantity + 1);
                              },
                              child: Icon(CupertinoIcons.plus_circle, color: Color(0xFF5B5BFF), size: 24),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(CupertinoIcons.delete, color: Colors.red),
                      onPressed: () => cart.removeItem(item.food),
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
                        Text('${cart.totalPrice}원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B5BFF))),
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