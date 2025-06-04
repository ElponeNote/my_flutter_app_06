# Flutter iOS 음식 주문 앱 Frontend 개발 가이드

## 1. 프로젝트 구조 및 아키텍처

### 1.1 MVVM 아키텍처 패턴 적용
기존 PRD를 바탕으로 MVVM (Model-View-ViewModel) 아키텍처 패턴을 적용하여 UI와 비즈니스 로직을 분리합니다.

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_dimensions.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   └── formatters.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_card.dart
│       └── loading_widget.dart
├── features/
│   ├── home/
│   │   ├── models/
│   │   │   ├── food_item.dart
│   │   │   └── category.dart
│   │   ├── views/
│   │   │   ├── home_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── category_section.dart
│   │   │   │   ├── promotion_banner.dart
│   │   │   │   └── recommendation_section.dart
│   │   └── view_models/
│   │       └── home_view_model.dart
│   ├── food_detail/
│   │   ├── models/
│   │   │   └── food_detail.dart
│   │   ├── views/
│   │   │   ├── food_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── option_selector.dart
│   │   │       └── add_to_cart_button.dart
│   │   └── view_models/
│   │       └── food_detail_view_model.dart
│   ├── cart/
│   │   ├── models/
│   │   │   └── cart_item.dart
│   │   ├── views/
│   │   │   ├── cart_screen.dart
│   │   │   └── widgets/
│   │   │       └── cart_item_widget.dart
│   │   └── view_models/
│   │       └── cart_view_model.dart
│   └── payment/
│       ├── models/
│       │   └── payment_info.dart
│       ├── views/
│       │   ├── payment_screen.dart
│       │   └── widgets/
│       │       ├── payment_summary.dart
│       │       └── payment_method_selector.dart
│       └── view_models/
│           └── payment_view_model.dart
└── services/
    ├── storage_service.dart
    └── animation_service.dart
```

### 1.2 상태 관리 선택
Flutter Provider가 2025년에도 신뢰할 수 있는 상태 관리 솔루션으로, 단순성과 다양성으로 널리 인정받고 있으며 중소규모 애플리케이션에 적합합니다.

## 2. 핵심 기술 스택 및 의존성

### 2.1 필수 Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  # 상태 관리
  provider: ^6.1.2
  
  # UI/UX
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
  
  # 애니메이션
  lottie: ^3.1.2
  animations: ^2.0.11
  
  # 이미지 처리
  cached_network_image: ^3.3.1
  
  # 로컬 저장소
  shared_preferences: ^2.2.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # 네비게이션
  go_router: ^14.2.7
  
  # 유틸리티
  intl: ^0.19.0
  uuid: ^4.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.12
  flutter_lints: ^4.0.0
```

### 2.2 2025년 트렌드 반영
2025년 Flutter 개발 트렌드에 따라 성능 최적화와 현대적인 UI 디자인 요소인 둥근 모서리와 부드러운 그림자를 적용합니다.

## 3. UI/UX 개선 사항

### 3.1 iOS 네이티브 경험 강화
```dart
// iOS 스타일 컴포넌트 사용 예시
import 'package:flutter/cupertino.dart';

class IOSStyleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16), // 2025 트렌드: 둥근 모서리
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey4.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      // ...
    );
  }
}
```

### 3.2 스켈레톤 로딩 구현
스켈레톤 로딩을 구현하여 네이티브 경험을 제공합니다.

```dart
class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  
  const SkeletonLoader({
    Key? key,
    required this.child,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.3, end: 0.7)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(_animation.value),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}
```

### 3.3 마이크로 인터랙션 추가
```dart
class AnimatedAddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isAdding;
  
  const AnimatedAddToCartButton({
    Key? key,
    required this.onPressed,
    this.isAdding = false,
  }) : super(key: key);

  @override
  State<AnimatedAddToCartButton> createState() => _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  
  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _checkController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: () {
        widget.onPressed();
        _checkController.forward().then((_) {
          Future.delayed(Duration(milliseconds: 500), () {
            _checkController.reset();
          });
        });
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleController, _checkController]),
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleController.value * 0.1),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: widget.isAdding 
                    ? Colors.green 
                    : CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(25),
              ),
              child: widget.isAdding
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.check_mark, color: Colors.white),
                        SizedBox(width: 8),
                        Text('담김!', style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : Text(
                      '담기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
```

## 4. 성능 최적화 전략

### 4.1 이미지 최적화
```dart
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  
  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => SkeletonLoader(
        isLoading: true,
        child: Container(width: width, height: height),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: Icon(CupertinoIcons.photo, color: Colors.grey),
      ),
      memCacheWidth: (width * MediaQuery.of(context).devicePixelRatio).round(),
      memCacheHeight: (height * MediaQuery.of(context).devicePixelRatio).round(),
    );
  }
}
```

### 4.2 레이지 로딩 구현
```dart
class LazyLoadingGrid extends StatefulWidget {
  final List<FoodItem> items;
  final Function(FoodItem) onItemTap;
  
  const LazyLoadingGrid({
    Key? key,
    required this.items,
    required this.onItemTap,
  }) : super(key: key);

  @override
  State<LazyLoadingGrid> createState() => _LazyLoadingGridState();
}

class _LazyLoadingGridState extends State<LazyLoadingGrid> {
  final ScrollController _scrollController = ScrollController();
  List<FoodItem> _displayedItems = [];
  int _currentIndex = 0;
  final int _batchSize = 10;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(_onScroll);
  }

  void _loadMoreItems() {
    final endIndex = math.min(
      _currentIndex + _batchSize, 
      widget.items.length
    );
    
    setState(() {
      _displayedItems.addAll(
        widget.items.sublist(_currentIndex, endIndex)
      );
      _currentIndex = endIndex;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      if (_currentIndex < widget.items.length) {
        _loadMoreItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _displayedItems.length,
      itemBuilder: (context, index) {
        return FoodCard(
          item: _displayedItems[index],
          onTap: () => widget.onItemTap(_displayedItems[index]),
        );
      },
    );
  }
}
```

## 5. 고급 애니메이션 구현

### 5.1 페이지 전환 애니메이션
```dart
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final String routeName;

  CustomPageRoute({
    required this.child,
    required this.routeName,
  }) : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 400),
        );
}
```

### 5.2 장바구니 알림 애니메이션
```dart
class CartNotificationOverlay extends StatefulWidget {
  final Widget child;
  final bool showNotification;
  final VoidCallback onContinueShopping;
  final VoidCallback onViewCart;
  
  const CartNotificationOverlay({
    Key? key,
    required this.child,
    required this.showNotification,
    required this.onContinueShopping,
    required this.onViewCart,
  }) : super(key: key);

  @override
  State<CartNotificationOverlay> createState() => _CartNotificationOverlayState();
}

class _CartNotificationOverlayState extends State<CartNotificationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late AnimationController _cardController;
  late Animation<double> _overlayAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    
    _overlayAnimation = Tween<double>(begin: 0.0, end: 0.5)
        .animate(CurvedAnimation(
          parent: _overlayController,
          curve: Curves.easeInOut,
        ));
    
    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: _cardController,
          curve: Curves.elasticOut,
        ));
  }

  @override
  void didUpdateWidget(CartNotificationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showNotification != oldWidget.showNotification) {
      if (widget.showNotification) {
        _overlayController.forward();
        _cardController.forward();
      } else {
        _overlayController.reverse();
        _cardController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showNotification)
          AnimatedBuilder(
            animation: Listenable.merge([_overlayController, _cardController]),
            builder: (context, child) {
              return Stack(
                children: [
                  // 배경 오버레이
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(_overlayAnimation.value),
                    ),
                  ),
                  // 알림 카드
                  Center(
                    child: Transform.scale(
                      scale: _cardAnimation.value,
                      child: Container(
                        margin: EdgeInsets.all(32),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Colors.green,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '장바구니에 담았습니다!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    onPressed: widget.onContinueShopping,
                                    color: Colors.grey[200],
                                    child: Text(
                                      '계속 쇼핑',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: CupertinoButton(
                                    onPressed: widget.onViewCart,
                                    color: CupertinoColors.activeBlue,
                                    child: Text('장바구니 보기'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
```

## 6. 접근성 및 다국어 지원

### 6.1 접근성 구현
```dart
class AccessibleFoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;
  
  const AccessibleFoodCard({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: `${item.name}, 가격 ${item.price}원`,
      hint: '음식 상세 정보를 보려면 두 번 탭하세요',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // ... UI 구현
        ),
      ),
    );
  }
}
```

### 6.2 다크모드 지원
```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    // ... 라이트 테마 설정
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    // ... 다크 테마 설정
  );
}
```

## 7. 테스트 전략

### 7.1 위젯 테스트
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/features/home/views/widgets/food_card.dart';

void main() {
  group('FoodCard Widget Tests', () {
    testWidgets('should display food information correctly', (tester) async {
      final foodItem = FoodItem(
        id: '1',
        name: 'Test Food',
        price: 10000,
        imageUrl: 'https://example.com/image.jpg',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FoodCard(
              item: foodItem,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Food'), findsOneWidget);
      expect(find.text('10,000원'), findsOneWidget);
    });
  });
}
```

## 8. 개발 우선순위 및 마일스톤

### Phase 1: 기본 구조 및 홈 화면 (1주)
1. **프로젝트 초기 설정**
   - MVVM 아키텍처 폴더 구조 생성
   - 필수 dependencies 설치
   - 테마 및 상수 설정

2. **홈 화면 기본 구현**
   - 카테고리 섹션 위젯
   - 프로모션 배너 (정적)
   - 추천 섹션 그리드 레이아웃

### Phase 2: 고급 UI 및 인터랙션 (2주)
1. **스켈레톤 로딩 구현**
2. **이미지 캐싱 및 최적화**
3. **마이크로 인터랙션 추가**
4. **음식 상세 페이지 구현**

### Phase 3: 장바구니 및 결제 (1주)
1. **장바구니 알림 애니메이션**
2. **결제 페이지 UI**
3. **결제 모션 구현**

### Phase 4: 최적화 및 테스트 (1주)
1. **성능 최적화**
2. **접근성 개선**
3. **단위 테스트 및 위젯 테스트**
4. **iOS 디바이스 테스트**

## 9. 추가 고려사항

### 9.1 코드 품질
- Flutter Lints 규칙 준수
- 코드 리뷰 체크리스트 작성
- 지속적인 리팩토링

### 9.2 사용자 피드백
- 베타 테스트 계획
- 사용성 테스트 시나리오
- 피드백 수집 및 개선 방안

이 Frontend 개발 가이드는 기존 PRD를 바탕으로 최신 Flutter 개발 트렌드와 iOS 네이티브 경험을 반영하여 보완된 내용입니다.

## 10. 단계별 UI/UX 개발 계획 (참고 이미지 기반)

아래는 실제 사용자 경험(이미지 1~6번) 흐름에 따라, 각 화면별로 단계적으로 개발을 진행하는 상세 계획입니다.

### 10.1 1단계: 홈 화면 (이미지 1~2)
- **구성요소**: 상단 앱바(로고, 검색), 카테고리(이모지+텍스트), 프로모션 배너(슬라이드), 추천/인기 음식 리스트(카드), 태그 버튼
- **UX 포인트**: iOS 스타일, 여백/정렬, 부드러운 스크롤, 그림자/둥근 모서리, 직관적 카테고리 선택
- **개발 목표**: 홈 화면 scaffold, 더미 데이터 기반 UI, Provider ViewModel 연결, 기본 네비게이션

### 10.2 2단계: 음식 리스트(카테고리별) (이미지 3)
- **구성요소**: 상단 앱바(뒤로가기, 카테고리명), 음식 리스트(이미지, 이름, 설명, 가격)
- **UX 포인트**: 카드형 리스트, 여백, 터치 영역, 빠른 네비게이션
- **개발 목표**: 카테고리별 음식 리스트 화면, 음식 모델/샘플 데이터, 네비게이션 연결

### 10.3 3단계: 음식 상세 (이미지 4)
- **구성요소**: 상단 앱바(뒤로가기), 음식 이미지, 이름, 가격, 설명, 수량 조절, 담기 버튼
- **UX 포인트**: 이미지 강조, 정보 계층화, 하단 고정 버튼, iOS 스타일
- **개발 목표**: 음식 상세 화면 scaffold, 수량 조절, 장바구니 담기 기능(더미)

### 10.4 4단계: 장바구니 알림 모달 (이미지 5)
- **구성요소**: 모달(장바구니 담김 안내, 상품/수량/가격, 메뉴 더 담기/결제하기 버튼)
- **UX 포인트**: 중앙 모달, 부드러운 애니메이션, 명확한 CTA
- **개발 목표**: 장바구니 알림 모달 위젯, 애니메이션, 네비게이션 연결

### 10.5 5단계: 결제 페이지 (이미지 6)
- **구성요소**: 주문 내역, 총 결제금액, 결제수단 선택(라디오), 결제 버튼
- **UX 포인트**: 카드형 정보, 명확한 금액 강조, iOS 스타일 라디오, 하단 고정 버튼
- **개발 목표**: 결제 화면 scaffold, 결제수단 선택, 결제 플로우(더미)

---

각 단계별로 UI/UX 완성도와 네비게이션, 상태 관리, 더미 데이터 기반 기능을 우선 구현하고, 이후 실제 데이터/API, 성능 최적화, 접근성, 애니메이션 등 고도화 작업을 진행합니다.

이 계획은 PRD.md와 연동하여, 실제 개발 우선순위와 마일스톤에도 반영합니다.
