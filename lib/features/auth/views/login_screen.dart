import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'widgets/social_login_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('로그인')),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            CupertinoTextField(
              placeholder: '이메일',
              keyboardType: TextInputType.emailAddress,
              onChanged: vm.setEmail,
            ),
            SizedBox(height: 16),
            CupertinoTextField(
              placeholder: '비밀번호',
              obscureText: true,
              onChanged: vm.setPassword,
            ),
            SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: (!vm.isLoginFormValid || vm.isLoading)
                  ? null
                  : () async {
                      final success = await vm.login();
                      if (success && context.mounted) {
                        context.go('/home');
                      }
                    },
              child: vm.isLoading ? CupertinoActivityIndicator() : Text('로그인'),
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
            SizedBox(height: 24),
            CupertinoButton(
              child: Text('아직 계정이 없으신가요? 회원가입'),
              onPressed: () => context.go('/signup'),
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