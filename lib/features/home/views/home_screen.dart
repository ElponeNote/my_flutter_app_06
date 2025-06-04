import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/category_section.dart';
import 'widgets/promotion_banner.dart';
import 'widgets/tag_filter_section.dart';
import 'widgets/food_recommendation_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final promotions = [
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            const HomeAppBar(),
            CategorySection(
              categories: vm.categories,
              selectedCategory: vm.selectedCategory,
              onCategorySelected: vm.selectCategory,
            ),
            PromotionBanner(promotions: promotions),
            TagFilterSection(
              tags: vm.tags,
              selectedTag: vm.selectedTag,
              onTagSelected: vm.selectTag,
            ),
            FoodRecommendationSection(foods: vm.foods),
          ],
        ),
      ),
    );
  }
} 