import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'food_recommendation_section.dart';
import 'dart:async';

class PromotionBanner extends StatefulWidget {
  final List<PromotionItem> promotions;
  const PromotionBanner({super.key, required this.promotions});

  @override
  State<PromotionBanner> createState() => _PromotionBannerState();
}

class _PromotionBannerState extends State<PromotionBanner> {
  int _current = 0;
  final PageController _controller = PageController();
  Timer? _timer;

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!mounted) return;
      final next = (_current + 1) % widget.promotions.length;
      _controller.animateToPage(
        next,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.promotions.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) {
              final promo = widget.promotions[i];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PromotionDetailScreen(promotion: promo),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: promo.bgColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 18),
                        Icon(promo.icon, size: 38, color: Colors.white),
                        SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                promo.subtitle,
                                style: TextStyle(
                                  color: Colors.white.withAlpha((255 * 0.9).toInt()),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 18),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.promotions.length, (i) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _current == i ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _current == i ? const Color(0xFF5B5BFF) : CupertinoColors.systemGrey3,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class PromotionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final String detail;
  final String period;
  final String notice;
  final List<FoodItem> foods;

  const PromotionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.detail,
    required this.period,
    required this.notice,
    required this.foods,
  });
}

// --- Promotion 상세페이지 임시 구현 ---
class PromotionDetailScreen extends StatelessWidget {
  final PromotionItem promotion;
  const PromotionDetailScreen({super.key, required this.promotion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(promotion.title, style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Icon(promotion.icon, size: 40, color: promotion.bgColor),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(promotion.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                    SizedBox(height: 4),
                    Text(promotion.period, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(promotion.detail, style: TextStyle(fontSize: 16)),
          SizedBox(height: 18),
          if (promotion.notice.isNotEmpty) ...[
            Text('유의사항', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 6),
            Text(promotion.notice, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
            SizedBox(height: 18),
          ],
          Text('적용 가능한 음식', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 10),
          ...promotion.foods.map((food) => ListTile(
                leading: Icon(Icons.fastfood, color: promotion.bgColor),
                title: Text(food.name),
                subtitle: food.tags.isNotEmpty ? Text(food.tags.join(', ')) : null,
              )),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: promotion.bgColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {},
              child: Text('바로 주문/적용', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
} 