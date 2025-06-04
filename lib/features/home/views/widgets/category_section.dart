import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryItem> categories;
  final ValueChanged<String>? onCategorySelected;
  final String? selectedCategory;

  const CategorySection({
    super.key,
    required this.categories,
    this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          final isSelected = item.key == selectedCategory;
          return GestureDetector(
            onTap: () => onCategorySelected?.call(item.key),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF5B5BFF) : CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF5B5BFF).withOpacity(0.15),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.emoji,
                    style: TextStyle(fontSize: 26),
                  ),
                  SizedBox(height: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryItem {
  final String key;
  final String emoji;
  final String label;

  const CategoryItem({required this.key, required this.emoji, required this.label});
} 