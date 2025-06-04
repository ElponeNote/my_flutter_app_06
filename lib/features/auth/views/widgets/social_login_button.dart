import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final String assetIcon;
  const SocialLoginButton({
    required this.onPressed,
    required this.text,
    required this.color,
    required this.assetIcon,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: color,
      borderRadius: BorderRadius.circular(8),
      padding: EdgeInsets.symmetric(vertical: 14),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetIcon, width: 24, height: 24),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
} 