import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;

const String serverUrl = 'http://143.248.196.37:3000';

void onLoginSuccess(String accessToken) {
  print('로그인 성공: $accessToken');
  // 여기에 로그인 성공시 실행할 로직을 추가

}

void onLoginFail(dynamic error) {
  print('로그인 실패: $error');
  // 여기에 로그인 실패시 실행할 로직을 추가
}

void onTokenValid(String userId, int expiresIn) {
  print('토큰 유효성 체크 성공: 사용자ID $userId, 만료시간 $expiresIn');
  // 여기에 토큰이 유효할 때 실행할 로직을 추가
}

void onTokenExpired(dynamic error) {
  print('토큰 만료: $error');
  // 여기에 토큰이 만료되었을 때 실행할 로직을 추가
}

Future<void> onUserInfoSuccess(User user) async {
  print('사용자 정보 요청 성공: '
      '회원번호: ${user.id}, '
      '닉네임: ${user.kakaoAccount?.profile?.nickname}, '
  );
  var data = {
    "username": user.kakaoAccount?.profile?.nickname,
    "uid": user.id,
    "password": "0000",
    "type": "kakao"
  };
  final response = await http.post(
    Uri.parse('$serverUrl/register'),
    body: jsonEncode(data),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 201) {
      print("성공");
  }
  else {
      print("실패");
  }
}

void onUserInfoFail(dynamic error) {
  print('사용자 정보 요청 실패: $error');
  // 여기에 사용자 정보 요청 실패시 실행할 로직을 추가
}

Future<void> kakaotalk_login() async {
  // 카카오톡 로그인 로직 구현
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      onLoginSuccess('카카오톡으로 로그인 성공');
    } catch (error) {
      onLoginFail(error);

      if (error is PlatformException && error.code == 'CANCELED') {
        // 로그인 취소로 처리
        return;
      }
    }

    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        onTokenValid(tokenInfo.id.toString(), tokenInfo.expiresIn);
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          onTokenExpired(error);
        } else {
          onLoginFail(error);
        }

        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          onLoginSuccess(token.accessToken);
        } catch (error) {
          onLoginFail(error);
        }
      }
    } else {
      onLoginFail('발급된 토큰 없음');
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        onLoginSuccess(token.accessToken);
      } catch (error) {
        onLoginFail(error);
      }
    }
  } else {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      onLoginSuccess(token.accessToken);
      try {
        User user = await UserApi.instance.me();
        onUserInfoSuccess(user);
      } catch (error) {
        onUserInfoFail(error);
      }
    } catch (error) {
      onLoginFail(error);
    }
  }
}
