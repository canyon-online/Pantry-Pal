class API {
  static const Map<String, String> postHeader = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String baseURL = 'testing.hasty.cc';
  static const String signup = 'api/register';
  static const String login = 'api/login';
  static const String verify = 'api/account/verify'; // the code from signup
  static const String requestVerify = 'api/account/verify/requestEmail';
  static const String googleLogin = 'api/login/google';
  static const String googleSignup = 'api/register/google';
  static const String imageUpload = 'api/upload'; // change this
}
