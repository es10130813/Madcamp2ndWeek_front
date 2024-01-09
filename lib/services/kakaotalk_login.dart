import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../pages/main_page.dart';
import 'auth_service.dart';

// 사용자 정보를 서버에서 확인하고, 로그인 또는 회원가입을 진행하는 함수
Future<void> checkAndLoginUser(BuildContext context, Map<String, dynamic> userData) async {
  var loginData = {
    'uid': userData['uid'],
    'password': '0000', // 카카오 로그인의 경우 임의의 비밀번호 설정
  };

  // 서버에 로그인 시도
  var loginResult = await login(loginData);
  print(loginResult);
  if (loginResult == '로그인 성공') {
    // 로그인 성공: 메인 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage(userId: userData['uid'], userName: userData['username'],)),
    );
  } else {
    // 로그인 실패: 회원가입 시도
    var signUpResult = await signUp(userData);
    if (signUpResult == '회원가입 성공') {
      // 회원가입 성공: 메인 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage(userId: userData['uid'], userName: userData['username'])),
      );
    } else {
      // 회원가입 실패: 오류 메시지 처리
      print('회원가입 실패: $signUpResult');
    }
  }
}


// 카카오톡 로그인을 처리하는 함수
Future<void> kakaotalk_login(BuildContext context) async {
  // 카카오톡 앱 설치 여부 확인
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공');
    } catch (error) {
      print('카카오톡 로그인 실패: $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
    }
  } else {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      print('카카오 계정으로 로그인 성공');
    } catch (error) {
      print('카카오 계정 로그인 실패: $error');
      return;
    }
  }

  try {
    User user = await UserApi.instance.me();
    var userData = {
      "username": user.kakaoAccount?.profile?.nickname,
      "uid": user.id.toString(),
      "password": "0000",
      "type": "kakao"
    };
    await checkAndLoginUser(context, userData);
  } catch (error) {
    print('사용자 정보 요청 실패: $error');
  }
}
