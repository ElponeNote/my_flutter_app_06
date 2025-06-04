import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/food_recommendation_section.dart';
import 'package:provider/provider.dart';
import '../../cart/view_models/cart_provider.dart';
import '../../cart/views/cart_screen.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodItem food;
  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(food.name, style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              final cartCount = context.watch<CartProvider>().items.length;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(CupertinoIcons.cart, color: Colors.grey[700]),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 4,
                      top: 8,
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
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Hero(
              tag: food.name,
              child: Image.network(
                food.imageUrl,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Icon(CupertinoIcons.star_fill, color: Color(0xFFFFB74D), size: 20),
              SizedBox(width: 6),
              Text(food.rating.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              Spacer(),
              Text('${food.price.toStringAsFixed(0)}원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF5B5BFF))),
            ],
          ),
          SizedBox(height: 16),
          Text(food.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: food.tags.map((tag) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(tag, style: TextStyle(fontSize: 13, color: Colors.black54)),
            )).toList(),
          ),
          SizedBox(height: 28),
          Text(
            '이 음식은 신선한 재료와 정성으로 만들어졌습니다. 푸짐한 양과 깊은 맛을 자랑하며, 많은 고객님들께 사랑받고 있습니다. 지금 바로 주문해보세요!',
            style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: CupertinoButton.filled(
              borderRadius: BorderRadius.circular(16),
              child: Text('장바구니 담기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => _CartModal(food: food),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CartModal extends StatefulWidget {
  final FoodItem food;
  const _CartModal({required this.food});

  @override
  State<_CartModal> createState() => _CartModalState();
}

class _CartModalState extends State<_CartModal> {
  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.food.price * _quantity;
    return DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.2,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.food.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.food.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 6),
                        Text('${widget.food.price.toStringAsFixed(0)}원', style: TextStyle(color: Color(0xFF5B5BFF), fontWeight: FontWeight.w600, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('수량', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 32,
                        onPressed: _decrement,
                        child: Icon(CupertinoIcons.minus_circle, color: Colors.grey, size: 28),
                      ),
                      SizedBox(width: 8),
                      Text('$_quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 32,
                        onPressed: _increment,
                        child: Icon(CupertinoIcons.plus_circle, color: Color(0xFF5B5BFF), size: 28),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('총액', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('${total.toStringAsFixed(0)}원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B5BFF))),
                ],
              ),
              SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: CupertinoButton(
                  color: Color(0xFF5B5BFF),
                  borderRadius: BorderRadius.circular(12),
                  child: Text('주문하기', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    // 장바구니에 추가
                    context.read<CartProvider>().addItem(widget.food, quantity: _quantity);
                    await showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green, size: 48),
                        content: Column(
                          children: [
                            SizedBox(height: 16),
                            Text('주문이 완료되었습니다!', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('빠르게 준비해드릴게요 :)'),
                          ],
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                              Navigator.of(context).pop(); // 바텀시트 닫기
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
        );
      },
    );
  }
} 