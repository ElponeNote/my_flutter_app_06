import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: GestureDetector(
        onTap: () {
          showSearch(context: context, delegate: _FoodSearchDelegate());
        },
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              SizedBox(width: 14),
              Icon(CupertinoIcons.search, color: Colors.grey[600], size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '메뉴, 음식, 가게명 검색',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 기존 검색 delegate 임포트 또는 복사 필요
class _FoodSearchDelegate extends SearchDelegate<String> {
  static List<String> recentQueries = [];

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) {
    // 실제 검색 결과는 추후 ViewModel 연동
    return Center(child: Text('검색 결과: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 최근 검색어 등 노출
    return ListView(
      children: recentQueries.map((q) => ListTile(
        title: Text(q),
        onTap: () => query = q,
      )).toList(),
    );
  }
} 