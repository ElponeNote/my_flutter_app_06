import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Image.asset(
            'assets/logo.png',
            width: 38,
            height: 38,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "스쿨 딜리버리",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF5B5BFF),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(CupertinoIcons.bell, size: 26, color: Colors.grey[700]),
          SizedBox(width: 18),
          Icon(CupertinoIcons.cart, size: 26, color: Colors.grey[700]),
        ],
      ),
    );
  }
} 