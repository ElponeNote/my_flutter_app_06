import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/home_view_model.dart';
import '../food_detail_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryKey;
  const CategoryDetailScreen({super.key, required this.categoryKey});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context, listen: false);
    final category = vm.categories.firstWhere((c) => c.key == categoryKey);
    final foods = vm.foods.where((f) => f.tags.contains(category.label)).toList();
    final categories = vm.categories;
    String selectedSort = '기본순';
    bool filterBaeminClub = false;
    bool filterCoupon = false;
    String deliveryType = '배달';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(category.label, style: TextStyle(color: Color(0xFF5B5BFF), fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Text('음식배달', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 16)),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              separatorBuilder: (_, __) => SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = categories[i];
                final isSelected = c.key == categoryKey;
                return GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => CategoryDetailScreen(categoryKey: c.key),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF5B5BFF) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Text(c.emoji, style: TextStyle(fontSize: 22)),
                        SizedBox(width: 6),
                        Text(
                          c.label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text('기본순'),
                    selected: selectedSort == '기본순',
                    onSelected: (_) {},
                    selectedColor: Color(0xFF5B5BFF).withAlpha(38),
                  ),
                  SizedBox(width: 6),
                  FilterChip(
                    label: Text('스쿨클럽'),
                    selected: filterBaeminClub,
                    onSelected: (_) {},
                    selectedColor: Color(0xFF5B5BFF).withAlpha(38),
                  ),
                  SizedBox(width: 6),
                  FilterChip(
                    label: Text('쿠폰·할인'),
                    selected: filterCoupon,
                    onSelected: (_) {},
                    selectedColor: Color(0xFF5B5BFF).withAlpha(38),
                  ),
                  SizedBox(width: 6),
                  FilterChip(
                    label: Text('배달·픽업 선택'),
                    selected: deliveryType == '배달',
                    onSelected: (_) {},
                    selectedColor: Color(0xFF5B5BFF).withAlpha(38),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          Expanded(
            child: foods.isEmpty
                ? Center(child: Text('해당 카테고리의 음식이 없습니다.', style: TextStyle(fontSize: 16)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: foods.length,
                    separatorBuilder: (_, __) => SizedBox(height: 18),
                    itemBuilder: (context, i) {
                      final food = foods[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(food: food),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(179),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  food.imageUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                  ),
                                ),
                              ),
                              SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('23~33분', style: TextStyle(fontSize: 13, color: Color(0xFF5B5BFF), fontWeight: FontWeight.bold)),
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF5B5BFF).withAlpha(31),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text('최소주문 12,000원', style: TextStyle(fontSize: 12, color: Color(0xFF5B5BFF))),
                                        ),
                                        Spacer(),
                                        Icon(Icons.star, color: Color(0xFFFFB74D), size: 18),
                                        SizedBox(width: 2),
                                        Text(food.rating.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      food.name,
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.purple[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text('10,000원 쿠폰', style: TextStyle(fontSize: 12, color: Colors.purple[800], fontWeight: FontWeight.bold)),
                                        ),
                                        SizedBox(width: 6),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text('무료배달', style: TextStyle(fontSize: 12, color: Colors.blue[800], fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 