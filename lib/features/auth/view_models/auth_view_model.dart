import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  String name = '';
  String address = '';
  String phone = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  String? error;
  final AuthService _authService = AuthService();

  String? nameError;
  String? addressError;
  String? phoneError;
  String? emailError;
  String? passwordError;

  void setName(String v) {
    name = v;
    nameError = v.trim().isEmpty ? '이름을 입력하세요.' : null;
    notifyListeners();
  }
  void setAddress(String v) {
    address = v;
    addressError = v.trim().isEmpty ? '주소를 입력하세요.' : null;
    notifyListeners();
  }
  void setPhone(String v) {
    phone = v;
    phoneError = _validatePhone(v);
    notifyListeners();
  }
  void setEmail(String v) {
    email = v;
    emailError = _validateEmail(v);
    notifyListeners();
  }
  void setPassword(String v) {
    password = v;
    passwordError = v.trim().isEmpty ? '비밀번호를 입력하세요.' : null;
    notifyListeners();
  }

  String? _validatePhone(String v) {
    final phoneReg = RegExp(r'^(01[016789]|02|0[3-9][0-9])[-]?[0-9]{3,4}[-]?[0-9]{4} 0$');
    if (v.trim().isEmpty) return '연락처를 입력하세요.';
    if (!phoneReg.hasMatch(v.trim())) return '유효한 연락처를 입력하세요.';
    return null;
  }
  String? _validateEmail(String v) {
    final emailReg = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,} 0$');
    if (v.trim().isEmpty) return '이메일을 입력하세요.';
    if (!emailReg.hasMatch(v.trim())) return '유효한 이메일 형식이 아닙니다.';
    return null;
  }

  bool get isFormValid =>
      nameError == null &&
      addressError == null &&
      phoneError == null &&
      emailError == null &&
      name.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      email.trim().isNotEmpty;

  bool get isLoginFormValid =>
      emailError == null &&
      passwordError == null &&
      email.trim().isNotEmpty &&
      password.trim().isNotEmpty;

  Future<bool> signup() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _authService.signup(
        name: name,
        address: address,
        phone: phone,
        email: email,
      );
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> kakaoLogin() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _authService.kakaoLogin();
      // 성공 시 추가 처리(예: 홈 이동)
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      // TODO: 실제 서버 연동
      await Future.delayed(Duration(seconds: 1));
      if (email == 'test@test.com' && password == '1234') {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('이메일 또는 비밀번호가 올바르지 않습니다.');
      }
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
} 