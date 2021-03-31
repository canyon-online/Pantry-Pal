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

  factory User.fromJson(Map<String, dynamic> data) {
    return User.fromMap(data);
  }

  String userAsString() {
    return '#${this.userId} ${this.name}';
  }

  bool operator ==(Object other) => other is User && other.userId == userId;

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() => userAsString();
}
