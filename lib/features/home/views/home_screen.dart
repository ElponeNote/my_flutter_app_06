import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/home_view_model.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/category_section.dart';
import 'widgets/promotion_banner.dart';
import 'widgets/tag_filter_section.dart';
import 'widgets/food_recommendation_section.dart';
import 'screens/category_detail_screen.dart';
import 'widgets/search_bar_section.dart';

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
        detail: '신규회원이라면 첫 주문 시 3,000원 즉시 할인! 가입만 해도 바로 사용 가능합니다.',
        period: '2024.06.01 ~ 2024.06.30',
        notice: '타 쿠폰과 중복 사용 불가. 1인 1회 한정.',
        foods: vm.foods.take(2).toList(),
      ),
      PromotionItem(
        title: '점심특가 20% 할인',
        subtitle: '오전 11시~오후 2시, 인기 메뉴 한정',
        icon: Icons.lunch_dining,
        bgColor: Color(0xFFFFB74D),
        detail: '점심시간(11~14시) 주문 시 인기 메뉴 20% 할인! 바쁜 점심, 저렴하게 즐기세요.',
        period: '상시 진행',
        notice: '일부 메뉴 제외, 자세한 내용은 앱 내 공지 참고.',
        foods: vm.foods.skip(1).take(2).toList(),
      ),
      PromotionItem(
        title: '리뷰 작성 시 1,000P 적립',
        subtitle: '주문 후 리뷰만 남겨도 적립!',
        icon: Icons.star,
        bgColor: Color(0xFF64B5F6),
        detail: '주문 후 리뷰를 남기면 1,000포인트 즉시 적립! 적립금은 다음 주문에 사용 가능.',
        period: '2024.06.01 ~ 2024.06.30',
        notice: '부적절한 리뷰는 적립금 지급이 제한될 수 있습니다.',
        foods: vm.foods,
      ),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            const HomeAppBar(),
            const SearchBarSection(),
            CategorySection(
              categories: vm.categories,
              selectedCategory: vm.selectedCategory,
              onCategorySelected: (categoryKey) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoryDetailScreen(categoryKey: categoryKey),
                  ),
                );
              },
            ),
            PromotionBanner(promotions: promotions),
            TagFilterSection(
              tags: vm.tags,
              selectedTag: vm.selectedTag,
              onTagSelected: vm.selectTag,
            ),
            FoodRecommendationSection(foods: vm.filteredFoods),
          ],
        ),
      ),
    );
  }
} 