class User {
  String userId;
  String name;
  String token;
  bool verified;

  User(
      {this.userId = 'NULL',
      this.name = 'NULL',
      this.token = 'NULL',
      this.verified = false});

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
        userId: data['userId'],
        name: data['name'],
        token: data['token'],
        verified: data['verified']);
  }
}
