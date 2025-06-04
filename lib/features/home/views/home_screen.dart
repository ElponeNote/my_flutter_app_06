import 'package:flutter/material.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/category_section.dart';
import 'widgets/promotion_banner.dart';
import 'widgets/tag_filter_section.dart';
import 'widgets/food_recommendation_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  String _selectedCategory = 'korean';
  final List<PromotionItem> _promotions = const [
    PromotionItem(
      title: '신규회원 첫 주문 3,000원 할인',
      subtitle: 'FOODIGO에서만! 오늘 가입 시 즉시 사용',
      icon: Icons.card_giftcard,
      bgColor: Color(0xFF5B5BFF),
    ),
    PromotionItem(
      title: '점심특가 20% 할인',
      subtitle: '오전 11시~오후 2시, 인기 메뉴 한정',
      icon: Icons.lunch_dining,
      bgColor: Color(0xFFFFB74D),
    ),
    PromotionItem(
      title: '리뷰 작성 시 1,000P 적립',
      subtitle: '주문 후 리뷰만 남겨도 적립!',
      icon: Icons.star,
      bgColor: Color(0xFF64B5F6),
    ),
  ];
  final List<String> _tags = const [
    '추천', '인기', '근처', '한식', '일식', '치킨', '피자', '카페', '디저트'
  ];
  String _selectedTag = '추천';
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
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80',
      rating: 4.6,
      price: 7200,
      tags: ['추천', '버거'],
    ),
    FoodItem(
      name: '마라탕',
      imageUrl: 'https://images.unsplash.com/photo-1519864600265-abb23847ef2c?auto=format&fit=crop&w=400&q=80',
      rating: 4.7,
      price: 12000,
      tags: ['인기', '중식', '매운맛'],
    ),
    FoodItem(
      name: '아메리카노',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80',
      rating: 4.9,
      price: 3500,
      tags: ['카페', '디저트'],
    ),
  ];

  void _onCategorySelected(String key) {
    setState(() {
      _selectedCategory = key;
    });
  }

  void _onTagSelected(String tag) {
    setState(() {
      _selectedTag = tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            HomeAppBar(),
            CategorySection(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: _onCategorySelected,
            ),
            PromotionBanner(promotions: _promotions),
            TagFilterSection(
              tags: _tags,
              selectedTag: _selectedTag,
              onTagSelected: _onTagSelected,
            ),
            FoodRecommendationSection(foods: _foods),
          ],
        ),
      ),
    );
  }
} 