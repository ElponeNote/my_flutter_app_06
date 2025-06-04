import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../food_detail_screen.dart';

class FoodRecommendationSection extends StatelessWidget {
  final List<FoodItem> foods;
  const FoodRecommendationSection({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
                  color: CupertinoColors.systemGrey4.withAlpha((255 * 0.18).toInt()),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                    tag: food.name,
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
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(CupertinoIcons.star_fill, color: Color(0xFFFFB74D), size: 18),
                          SizedBox(width: 4),
                          Text(
                            food.rating.toStringAsFixed(1),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            '${food.price.toStringAsFixed(0)}원',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5B5BFF)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        food.name,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: food.tags.map((tag) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey5,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        )).toList(),
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
    );
  }
}

class FoodItem {
  final String name;
  final String imageUrl;
  final double rating;
  final int price;
  final List<String> tags;

  const FoodItem({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.tags,
  });
}

class FoodOption {
  final String name;
  final int price;
  const FoodOption({required this.name, required this.price});
} 