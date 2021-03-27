class User {
  String userId;
  String name;
  String token;

  User({this.userId = 'NULL', this.name = 'NULL', this.token = 'NULL'});

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
        userId: data['userId'], name: data['name'], token: data['token']);
  }
}
