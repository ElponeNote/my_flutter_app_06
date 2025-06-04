import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/food_recommendation_section.dart';
import 'package:provider/provider.dart';
import '../../cart/view_models/cart_provider.dart';
import '../../cart/views/cart_screen.dart';
import '../view_models/food_detail_view_model.dart';
import '../../cart/views/payment_screen.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodItem food;
  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodDetailViewModel(food: food),
      child: const _FoodDetailView(),
    );
  }
}

class _FoodDetailView extends StatelessWidget {
  const _FoodDetailView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FoodDetailViewModel>();
    final food = vm.food;
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
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 60),
                ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('수량', style: TextStyle(fontSize: 16)),
              SizedBox(width: 12),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(32, 32),
                onPressed: vm.decrement,
                child: Icon(CupertinoIcons.minus_circle, color: Colors.grey, size: 28),
              ),
              SizedBox(width: 8),
              Text('${vm.quantity}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(32, 32),
                onPressed: vm.increment,
                child: Icon(CupertinoIcons.plus_circle, color: Color(0xFF5B5BFF), size: 28),
              ),
              SizedBox(width: 24),
              Text('총액', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(width: 8),
              Text('${vm.total.toStringAsFixed(0)}원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B5BFF))),
            ],
          ),
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
          SizedBox(height: 24),
          Text('추가 옵션', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          ...vm.options.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: RadioListTile<FoodOption>(
                  value: option,
                  groupValue: vm.selectedOption,
                  onChanged: vm.selectOption,
                  title: Text(
                    '${option.name} (+${option.price}원)',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                ),
              )),
          if (vm.selectedOption != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text('옵션이 총액에 반영됩니다.', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('장바구니에 담았습니다!'),
                    duration: Duration(seconds: 1),
                  ),
                );
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => _CartModal(vm: vm),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CartModal extends StatelessWidget {
  final FoodDetailViewModel vm;
  const _CartModal({required this.vm});

  @override
  Widget build(BuildContext context) {
    final food = vm.food;
    final cart = context.read<CartProvider>();
    final memoController = TextEditingController();
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
                      food.imageUrl,
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
                        Text(food.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 6),
                        Text('${food.price.toStringAsFixed(0)}원', style: TextStyle(color: Color(0xFF5B5BFF), fontWeight: FontWeight.w600, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              TextField(
                controller: memoController,
                decoration: InputDecoration(
                  labelText: '요청사항(메모)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                maxLines: 2,
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
                        minimumSize: const Size(32, 32),
                        onPressed: vm.decrement,
                        child: Icon(CupertinoIcons.minus_circle, color: Colors.grey, size: 28),
                      ),
                      SizedBox(width: 8),
                      Text('${vm.quantity}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(32, 32),
                        onPressed: vm.increment,
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
                  Text('${vm.total.toStringAsFixed(0)}원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B5BFF))),
                ],
              ),
              SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: CupertinoButton(
                  color: Color(0xFF5B5BFF),
                  borderRadius: BorderRadius.circular(12),
                  child: Text('주문하기', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () async {
                    vm.addToCart(cart, memo: memoController.text.isNotEmpty ? memoController.text : null);
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => _CartAddedDialog(
                        foodName: food.name,
                        quantity: vm.quantity,
                        total: vm.total,
                        onAddMore: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                          Navigator.of(context).pop(); // 바텀시트 닫기
                        },
                        onCheckout: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                          Navigator.of(context).pop(); // 바텀시트 닫기
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => PaymentScreen()),
                          );
                        },
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

class _CartAddedDialog extends StatelessWidget {
  final String foodName;
  final int quantity;
  final int total;
  final VoidCallback onAddMore;
  final VoidCallback onCheckout;
  const _CartAddedDialog({
    required this.foodName,
    required this.quantity,
    required this.total,
    required this.onAddMore,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: EdgeInsets.symmetric(horizontal: 36),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Color(0xFF5B5BFF), size: 44),
            SizedBox(height: 12),
            Text('장바구니에 담았어요', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            Text('$foodName $quantity개', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('총 $total원', style: TextStyle(fontSize: 15, color: Color(0xFF5B5BFF), fontWeight: FontWeight.w600)),
            SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onAddMore,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Color(0xFF5B5BFF)),
                    ),
                    child: Text('메뉴 더 담기', style: TextStyle(color: Color(0xFF5B5BFF), fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5B5BFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('결제하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 