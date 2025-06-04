import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class AuthService {
  Future<void> signup({
    required String name,
    required String address,
    required String phone,
    required String email,
  }) async {
    // TODO: 실제 서버 연동 또는 로컬 저장 구현
    await Future.delayed(Duration(seconds: 1));
    // 성공 시 아무것도 안 함, 실패 시 throw Exception('회원가입 실패')
  }

  Future<void> kakaoLogin() async {
    try {
      bool installed = await isKakaoTalkInstalled();
      await (installed
          ? UserApi.instance.loginWithKakaoTalk()
          : UserApi.instance.loginWithKakaoAccount());
      await UserApi.instance.me();
      // user.kakaoAccount?.email, user.kakaoAccount?.profile?.nickname 등 활용 가능
      // TODO: 서버에 회원가입/로그인 처리
    } catch (e) {
      throw Exception('카카오 로그인 실패: $e');
    }
  }
} 