import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = '신용카드';
  final _couponController = TextEditingController();
  int _usedPoint = 0;
  int _discount = 0;
  final int _userPoint = 0; // 샘플: 보유 포인트
  String? _appliedCoupon;
  static const int minOrderAmount = 12000;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final total = cart.totalPrice;
    final discountedTotal = (total - _discount - _usedPoint).clamp(0, total);
    final isBelowMinOrder = discountedTotal < minOrderAmount;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('결제하기', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('주문 내역', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${item.food.name} x${item.quantity}', style: const TextStyle(fontSize: 15)),
                                  if (item.option != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text('옵션: ${item.option!.name} (+${item.option!.price}원)', style: TextStyle(fontSize: 12, color: Colors.black87)),
                                    ),
                                  if (item.memo != null && item.memo!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Text('메모: ${item.memo}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                    ),
                                ],
                              ),
                            ),
                            Text('${item.totalPrice}원', style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('총 결제금액', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('$total원', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5B5BFF))),
                    ],
                  ),
                  if (_discount > 0 || _usedPoint > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('할인/포인트', style: TextStyle(fontSize: 15, color: Colors.green[700], fontWeight: FontWeight.w500)),
                          Text('-${_discount + _usedPoint}원', style: TextStyle(fontSize: 15, color: Colors.green[700], fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  if (_discount > 0 || _usedPoint > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('최종 결제금액', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('$discountedTotal원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5B5BFF))),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('쿠폰/포인트', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: InputDecoration(
                            hintText: '쿠폰코드 입력',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5B5BFF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          final code = _couponController.text.trim();
                          if (code == 'SAVE3000') {
                            setState(() {
                              _appliedCoupon = code;
                              _discount = 3000;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('3,000원 쿠폰이 적용되었습니다.')));
                          } else {
                            setState(() {
                              _appliedCoupon = null;
                              _discount = 0;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('유효하지 않은 쿠폰입니다.')));
                          }
                        },
                        child: Text('쿠폰 적용', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      if (_appliedCoupon != null)
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _appliedCoupon = null;
                              _discount = 0;
                              _couponController.clear();
                            });
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('포인트 사용 (보유: $_userPoint원)', style: TextStyle(fontSize: 15)),
                      Text('$_usedPoint원', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B5BFF))),
                    ],
                  ),
                  Slider(
                    value: _usedPoint.toDouble(),
                    min: 0,
                    max: _userPoint.toDouble(),
                    divisions: (_userPoint / 100).floor() == 0 ? null : (_userPoint / 100).floor(),
                    label: '$_usedPoint',
                    onChanged: (v) {
                      setState(() {
                        _usedPoint = v.round();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('결제 수단', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  RadioListTile<String>(
                    value: '신용카드',
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                    title: const Text('신용카드'),
                  ),
                  RadioListTile<String>(
                    value: '간편결제',
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                    title: const Text('간편결제'),
                  ),
                  RadioListTile<String>(
                    value: '휴대폰 결제',
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                    title: const Text('휴대폰 결제'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (isBelowMinOrder)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red, size: 20),
                    SizedBox(width: 6),
                    Text('최소 주문 금액은 $minOrderAmount원입니다.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBelowMinOrder ? Colors.grey[400] : const Color(0xFF5B5BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: isBelowMinOrder
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('최소 주문 금액 $minOrderAmount원 이상부터 결제할 수 있습니다.')),
                        );
                      }
                    : () async {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            insetPadding: EdgeInsets.symmetric(horizontal: 36),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, color: Color(0xFF5B5BFF), size: 44),
                                  SizedBox(height: 12),
                                  Text('결제가 완료되었습니다', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  SizedBox(height: 14),
                                  Text('총 결제금액: $discountedTotal원', style: TextStyle(fontSize: 15, color: Color(0xFF5B5BFF), fontWeight: FontWeight.w600)),
                                  SizedBox(height: 8),
                                  Text('맛있게 드세요! 😊', style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                                  SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF5B5BFF),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      },
                                      child: Text('홈으로 돌아가기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                child: Text('$discountedTotal원 결제하기', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 