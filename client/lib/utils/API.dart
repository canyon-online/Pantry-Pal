import 'dart:io';
import 'dart:convert';
import 'package:client/models/Ingredient.dart';
import 'package:client/models/Recipe.dart';
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
  static const String likeRecipe =
      'api/recipes'; // + '/recipeID + '/favorite' (Post)
  static const String clickRecipe = 'api/recipes'; // + '/recipeID (Get)
  static const String requestReset = 'api/account/forgotpassword/requestemail';
  static const String resetPassword = 'api/account/forgotpassword';
  static const String userInfo = 'api/users/me';
  static const String favoriteRecipes = 'api/users/me/favorites';
  static const String myRecipes = 'api/users/me/recipes';

  // API call to submit an ingredient based using a user token and the name.
  Future<Map<String, dynamic>> submitIngredient(
      String token, String name) async {
    Map<String, String> ingredient = {'name': name};

    final response =
        await http.post(Uri.https(API.baseURL, API.createIngredient),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'bearer $token'
            },
            body: jsonEncode(ingredient));

    return jsonDecode(response.body);
  }

  // API call to submit a recipe based using a user token and a map of recipe parts.
  Future<Map<String, dynamic>> submitRecipe(
      String token, Map<String, dynamic> recipe) async {
    print('Sending new recipe ' + recipe.toString());

    final response = await http.post(Uri.https(API.baseURL, API.createRecipe),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'bearer $token'
        },
        body: jsonEncode(recipe));

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> searchFromIngredients(String token, int offset,
      int limit, Set<Ingredient> ingredients, String query) async {
    Map<String, String> params = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'sortBy': 'numFavorites',
      'direction': '-1',
      'name': query,
      'ingredients':
          ingredients.fold('any', (prev, element) => prev + ',${element.id}')
    };

    var response = await http.get(
        Uri.https(API.baseURL, API.searchRecipe, params),
        headers: {HttpHeaders.authorizationHeader: 'bearer $token'});

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  // API call to fetch recipes based on an offset and limit.
  Future<List<Recipe>> getRecipes(String token, int offset, int limit) async {
    Map<String, String> params = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'sortBy': 'numFavorites',
      'direction': '-1'
    };

    var response = await http.get(
        Uri.https(API.baseURL, API.searchRecipe, params),
        headers: {HttpHeaders.authorizationHeader: 'bearer $token'});

    // Return a list of the recipes fetched as recipe objects.
    List<dynamic> recipes = jsonDecode(response.body)['recipes'];
    return recipes.map<Recipe>((item) => Recipe.fromMap(item)).toList();
  }

  Future<List<Recipe>> getFavoriteRecipes(
      String token, int offset, int limit) async {
    Map<String, String> params = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'sortBy': 'numFavorites',
      'direction': '-1'
    };

    var response = await http.get(
        Uri.https(API.baseURL, API.searchRecipe, params),
        headers: {HttpHeaders.authorizationHeader: 'bearer $token'});

    // Return a list of the recipes fetched as recipe objects.
    List<dynamic> recipes = jsonDecode(response.body)['recipes'];
    return recipes.map<Recipe>((item) => Recipe.fromMap(item)).toList();
  }

  Future<List<Recipe>> getMyRecipes(String token, int offset, int limit) async {
    Map<String, String> params = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'sortBy': 'numFavorites',
      'direction': '-1'
    };

    var response = await http.get(
        Uri.https(API.baseURL, API.searchRecipe, params),
        headers: {HttpHeaders.authorizationHeader: 'bearer $token'});

    // Return a list of the recipes fetched as recipe objects.
    List<dynamic> recipes = jsonDecode(response.body)['recipes'];
    return recipes.map<Recipe>((item) => Recipe.fromMap(item)).toList();
  }

  // API Call to fetch ingredients based off an (optional?) filter.
  Future<List<Ingredient>> getIngredients(String token, String filter) async {
    var response = await http.get(
        Uri.https(API.baseURL, API.searchIngredient, {'name': filter}),
        headers: {HttpHeaders.authorizationHeader: 'bearer $token'});
    // Return a list of the ingredients fetched as ingredient objects.
    return Ingredient.fromJsonList(json.decode(response.body)['ingredients']);
  }

  // API call to upload a PickedFile to the imageUpload endpoint.
  Future<Map<String, dynamic>> uploadFile(
      String token, PickedFile file, String name) async {
    var request =
        http.MultipartRequest('POST', Uri.https(API.baseURL, API.imageUpload));
    request.headers.addAll({HttpHeaders.authorizationHeader: 'bearer $token'});

    // Add files to the request.
    request.files.add(http.MultipartFile(
      'image',
      file.openRead(),
      await file.readAsBytes().then((value) => value.length),
      filename: name,
      contentType: MediaType('image', 'jpeg'),
    ));

    // Send the request.
    final response = await http.Response.fromStream(await request.send());

    // Fetch response data and add the status code to it.
    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  // API call to send email verification when resetting password.
  Future<Map<String, dynamic>> sendPasswordReset(String email) async {
    final response = await http.post(
      Uri.https(API.baseURL, API.requestReset),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{'email': email}),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  Future<Map<String, dynamic>> getUserInfo(String token) async {
    final response = await http
        .get(Uri.https(API.baseURL, API.userInfo), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'bearer $token'
    });

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  // API call to send email verification when resetting password.
  Future<Map<String, dynamic>> verifyPasswordReset(
      String email, String verification, String password) async {
    final Map<String, dynamic> loginData = {
      'email': email,
      'code': verification,
      'password': password
    };

    final response = await http.post(
      Uri.https(API.baseURL, API.resetPassword),
      headers: API.postHeader,
      body: jsonEncode(loginData),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  // API call to send email verification when old code expired.
  Future<Map<String, dynamic>> requestVerification(String token) async {
    final response = await http.post(
      Uri.https(API.baseURL, API.requestVerify),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'bearer $token'
      },
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  // API call to sign in/up through google.
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

  // API call to fetch a JWT to remain logged in.
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

  // API call to create a new user.
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

  // API call to validate verification code to authenticate an account.
  Future<Map<String, dynamic>> checkVerification(
      String token, String code) async {
    final Map<String, dynamic> verifyData = {'code': code};

    final response = await http.post(Uri.https(API.baseURL, API.verify),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'bearer $token'
        },
        body: jsonEncode(verifyData));

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  // API call to add a like to a recipe
  Future<Map<String, dynamic>> doLikeRecipe(
      String token, String recipeId) async {
    final response = await http.post(
        Uri.https(API.baseURL, API.likeRecipe + '/$recipeId/favorite'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'bearer $token'
        });

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }

  // API call to fetch recipes based on an offset and limit.
  Future<Map<String, dynamic>> doClickRecipe(
      String token, String recipeId) async {
    var response = await http.get(
        Uri.https(API.baseURL, API.likeRecipe + '/$recipeId'),
        headers: {HttpHeaders.authorizationHeader: 'bearer $token'});

    Map<String, dynamic> responseData = jsonDecode(response.body);
    responseData['code'] = response.statusCode;
    return responseData;
  }
}
