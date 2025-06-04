import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'widgets/social_login_button.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('회원가입')),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            CupertinoTextField(
              placeholder: '이름',
              onChanged: vm.setName,
              decoration: BoxDecoration(
                border: Border.all(
                  color: vm.nameError != null ? CupertinoColors.systemRed : CupertinoColors.separator,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (vm.nameError != null)
              Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(vm.nameError!, style: TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
              ),
            SizedBox(height: 16),
            CupertinoTextField(
              placeholder: '주소',
              onChanged: vm.setAddress,
              decoration: BoxDecoration(
                border: Border.all(
                  color: vm.addressError != null ? CupertinoColors.systemRed : CupertinoColors.separator,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (vm.addressError != null)
              Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(vm.addressError!, style: TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
              ),
            SizedBox(height: 16),
            CupertinoTextField(
              placeholder: '연락처',
              keyboardType: TextInputType.phone,
              onChanged: vm.setPhone,
              decoration: BoxDecoration(
                border: Border.all(
                  color: vm.phoneError != null ? CupertinoColors.systemRed : CupertinoColors.separator,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (vm.phoneError != null)
              Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(vm.phoneError!, style: TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
              ),
            SizedBox(height: 16),
            CupertinoTextField(
              placeholder: '이메일',
              keyboardType: TextInputType.emailAddress,
              onChanged: vm.setEmail,
              decoration: BoxDecoration(
                border: Border.all(
                  color: vm.emailError != null ? CupertinoColors.systemRed : CupertinoColors.separator,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (vm.emailError != null)
              Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(vm.emailError!, style: TextStyle(color: CupertinoColors.systemRed, fontSize: 13)),
              ),
            SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: (!vm.isFormValid || vm.isLoading)
                  ? null
                  : () async {
                      final success = await vm.signup();
                      if (success && context.mounted) {
                        context.go('/home');
                      }
                    },
              child: vm.isLoading ? CupertinoActivityIndicator() : Text('회원가입'),
            ),
            SizedBox(height: 24),
            SocialLoginButton(
              onPressed: () async {
                await vm.kakaoLogin();
                if (vm.error == null && context.mounted) {
                  context.go('/home');
                }
              },
              text: '카카오로 시작하기',
              color: Color(0xFFFEE500),
              assetIcon: 'assets/kakao.png',
            ),
            if (vm.error != null) ...[
              SizedBox(height: 16),
              Text(vm.error!, style: TextStyle(color: CupertinoColors.systemRed)),
            ],
          ],
        ),
      ),
    );
  }
} 