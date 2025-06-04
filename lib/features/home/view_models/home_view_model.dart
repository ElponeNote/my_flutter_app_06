import 'package:flutter/material.dart';
import '../views/widgets/category_section.dart';
import '../views/widgets/food_recommendation_section.dart';

class HomeViewModel extends ChangeNotifier {
  final List<CategoryItem> _categories = const [
    CategoryItem(key: 'korean', emoji: '🍚', label: '한식'),
    CategoryItem(key: 'japanese', emoji: '🍣', label: '일식'),
    CategoryItem(key: 'chicken', emoji: '🍗', label: '치킨'),
    CategoryItem(key: 'pizza', emoji: '🍕', label: '피자'),
    CategoryItem(key: 'burger', emoji: '🍔', label: '버거'),
    CategoryItem(key: 'cafe', emoji: '☕️', label: '카페'),
    CategoryItem(key: 'dessert', emoji: '🧁', label: '디저트'),
    CategoryItem(key: 'etc', emoji: '🍱', label: '기타'),
  ];
  final List<String> _tags = const [
    '추천', '인기', '근처', '한식', '일식', '치킨', '피자', '카페', '디저트'
  ];
  final List<FoodItem> _foods = const [
    FoodItem(
      name: '치즈돈까스',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80',
      rating: 4.8,
      price: 9500,
      tags: ['인기', '일식', '치즈'],
    ),
    FoodItem(
      name: '불고기버거',
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=400&q=80',
      rating: 4.6,
      price: 7200,
      tags: ['추천', '버거'],
    ),
    FoodItem(
      name: '마라탕',
      imageUrl: 'https://images.unsplash.com/photo-1502741338009-cac2772e18bc?auto=format&fit=crop&w=400&q=80',
      rating: 4.7,
      price: 12000,
      tags: ['인기', '중식', '매운맛'],
    ),
    FoodItem(
      name: '아메리카노',
      imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=400&q=80',
      rating: 4.9,
      price: 3500,
      tags: ['카페', '디저트'],
    ),
  ];
  String _selectedCategory = 'korean';
  String _selectedTag = '추천';

  List<CategoryItem> get categories => _categories;
  List<String> get tags => _tags;
  List<FoodItem> get foods => _foods;
  String get selectedCategory => _selectedCategory;
  String get selectedTag => _selectedTag;

  // 태그별 음식 필터링
  List<FoodItem> get filteredFoods => _selectedTag == '추천'
      ? _foods
      : _foods.where((f) => f.tags.contains(_selectedTag)).toList();

  // 음식명 기준 실시간 검색
  List<FoodItem> searchFoods(String query) {
    if (query.isEmpty) return [];
    return _foods.where((f) => f.name.contains(query)).toList();
  }

  void selectCategory(String key) {
    _selectedCategory = key;
    notifyListeners();
  }

  void selectTag(String tag) {
    _selectedTag = tag;
    notifyListeners();
  }
} 