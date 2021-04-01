import 'dart:io';
import 'dart:convert';
import 'package:client/models/Ingredient.dart';
import 'package:client/models/Recipe.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:image_picker/image_picker.dart';

class API {
  static const Map<String, String> postHeader = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const String baseURL = 'testing.hasty.cc';
  static const String signup = 'api/register';
  static const String login = 'api/login';
  static const String verify = 'api/account/verify';
  static const String requestVerify = 'api/account/verify/requestEmail';
  static const String googleLogin = 'api/login/google';
  static const String googleSignup = 'api/register/google';
  static const String imageUpload = 'api/upload';
  static const String searchIngredient = 'api/ingredients';
  static const String createIngredient = 'api/ingredients';
  static const String searchRecipe = 'api/recipes';
  static const String createRecipe = 'api/recipes';

  Future<Map<String, dynamic>> submitRecipe(
      String token, Map<String, dynamic> recipe) async {
    print('sending ' + recipe.toString());

    final response = await http.post(Uri.https(API.baseURL, API.createRecipe),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'bearer ' + token
        },
        body: jsonEncode(recipe));

    return jsonDecode(response.body);
  }

  Future<List<Recipe>> getRecipes(String token, int offset, int limit) async {
    Map<String, String> params = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'sortBy': 'numFavorites',
      'direction': '-1'
    };

    var response = await http.get(
        Uri.https(API.baseURL, API.searchRecipe, params),
        headers: {HttpHeaders.authorizationHeader: 'bearer ' + token});

    List<dynamic> recipes = jsonDecode(response.body)['recipes'];

    return recipes.map<Recipe>((item) => Recipe.fromMap(item)).toList();
  }

  Future<List<Ingredient>> getIngredients(String token, String filter) async {
    var response = await http.get(
        Uri.https(API.baseURL, API.searchIngredient, {'name': filter}),
        headers: {HttpHeaders.authorizationHeader: 'bearer ' + token});
    return Ingredient.fromJsonList(json.decode(response.body)['ingredients']);
  }

  Future<Map<String, dynamic>> uploadFile(
      String token, PickedFile file, String name) async {
    var request =
        http.MultipartRequest('POST', Uri.https(API.baseURL, API.imageUpload));
    request.headers
        .addAll({HttpHeaders.authorizationHeader: 'bearer ' + token});

    request.files.add(http.MultipartFile(
      'image',
      file.openRead(),
      await file.readAsBytes().then((value) => value.length),
      filename: name,
      contentType: MediaType('image', 'jpeg'),
    ));

    http.Response response =
        await http.Response.fromStream(await request.send());

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> sendEmailVerification(String email) async {
    final response = await http.post(
      Uri.https('jsonplaceholder.typicode.com', 'posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{'email': email}),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> requestVerification(String token) async {
    var result;

    final response = await http.post(
      Uri.https(API.baseURL, API.requestVerify),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'bearer ' + token
      },
    );

    try {
      if (response.statusCode == 200) {
        result = {'status': true, 'message': 'Sent a new verification email'};
      } else {
        result = {
          'status': false,
          'message': 'Failed to send a new verification email'
        };
      }
    } catch (on, stacktrace) {
      print(stacktrace.toString());
      result = {
        'status': false,
        'message': 'Failed to send a new verification email'
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> googleVerification(String token) async {
    final Map<String, dynamic> loginData = {'token': token};

    final response = await http.post(
      Uri.https(API.baseURL, API.googleLogin),
      headers: API.postHeader,
      body: jsonEncode(loginData),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  Future<Map<String, dynamic>> doLogin(String email, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    final response = await http.post(
      Uri.https(API.baseURL, API.login),
      headers: API.postHeader,
      body: jsonEncode(loginData),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  Future<Map<String, dynamic>> doSignup(
      String name, String email, String password) async {
    final Map<String, dynamic> signupData = {
      'name': name,
      'email': email,
      'password': password
    };

    final response = await http.post(
      Uri.https(API.baseURL, API.signup),
      headers: API.postHeader,
      body: jsonEncode(signupData),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  Future<Map<String, dynamic>> checkVerification(
      String token, String code) async {
    final Map<String, dynamic> verifyData = {'code': code};

    final response = await http.post(Uri.https(API.baseURL, API.verify),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'bearer ' + token
        },
        body: jsonEncode(verifyData));

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }
}
